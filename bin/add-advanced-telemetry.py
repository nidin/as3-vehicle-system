#!/usr/bin/python

#*************************************************************************
#
# ADOBE CONFIDENTIAL
# ___________________
#
#  Copyright 2011 Adobe Systems Incorporated
#  All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains
# the property of Adobe Systems Incorporated and its suppliers,
# if any.  The intellectual and technical concepts contained
# herein are proprietary to Adobe Systems Incorporated and its
# suppliers and are protected by trade secret or copyright law.
# Dissemination of this information or reproduction of this material
# is strictly forbidden unless prior written permission is obtained
# from Adobe Systems Incorporated.
#**************************************************************************

#**************************************************************************
#
# Run this script on your SWF to make it generate advanced telemetry, which is
# needed for Monocle's ActionScript Sampler, DisplayList Rendering Details, and
# Stage3D Recording features.
#
# This is a temporary stopgap. Future versions of the ActionScript compiler and
# Flash Builder will support this option directly.
#
# Run with no arguments to see usage.
#
#**************************************************************************

from __future__ import division

import os
import sys
import tempfile
import subprocess
import shutil
import struct
import zlib
import hashlib
import inspect

class zlibfile(object):
    def __init__(self, f, isCompressed):
        self.data = f.read()
        f.close()
        if isCompressed:
            d = zlib.decompressobj()
            self.data = d.decompress(self.data)

    def read(self, num=1):
        result = self.data[:num]
        self.data = self.data[num:]
        return result

    def close(self):
        self.data = None

    def flush(self):
        pass

def outputInt(o, i):
    o.write(struct.pack('I', i))

def output(o, bs):
    o.write(bs)

def outputTelemetryTag(o, passwordClear):

    lengthBytes = 2 # reserve
    if passwordClear:
        sha = hashlib.sha256()
        sha.update(passwordClear)
        passwordDigest = sha.digest()
        lengthBytes += len(passwordDigest)

    # Record header
    code = 93
    if lengthBytes >= 63:
        output(o, struct.pack('<HI', code << 6 | 0x3f, lengthBytes))
    else:
        output(o, struct.pack('<H', code << 6 | lengthBytes))

    # Reserve
    output(o, struct.pack('<H', 0))
    
    # Password
    if passwordClear:
        output(o, passwordDigest)

if __name__ == "__main__":

    if len(sys.argv) < 2:
        print("Usage: %s SWF_FILE [PASSWORD]" % os.path.basename(inspect.getfile(inspect.currentframe())))
	print("\nIf PASSWORD is provided, then a password will be required to view advanced telemetry in Monocle.")
        sys.exit(-1)

    infile = sys.argv[1]
    passwordClear = sys.argv[2] if len(sys.argv) >= 3 else None

    sf = open(infile, "rb")
    magic = sf.read(3)
    v = sf.read(1)
    ln = struct.unpack("<I", sf.read(4))[0]
    f = zlibfile(sf, magic == "CWS")

    o = open(infile, 'wb')
    o.write("FWS")
    output(o,  v)
    outputInt(o,  ln)

    rs = f.read(1)
    r = struct.unpack("B", rs)
    rbits = (r[0] & 0xff) >> 3
    rrbytes = (7 + (rbits*4) - 3) / 8;
    hashstart = o.tell()
    output(o,  rs)
    output(o,  f.read((int)(rrbytes) + 4))

    state_lookingForFileAttributes = 1
    state_lookingForMetadata = 2
    state_gotMetadata = 3
    state_done = 4

    state = state_lookingForFileAttributes
    tag = -1
    abcid = 0
    injected = False
    abctagcount = 0
    while tag != 0:
        rh = f.read(2)
        assert(rh != "")
        recordheader = struct.unpack("BB", rh) # Why don't you use h?
        code = ((recordheader[1]&0xff) << 8) | (recordheader[0]&0xff)
        tag = (code >> 6)
        length = code & 0x3f
        bhead = 2
        longlength = None

        assert(code != 93) # tool doesn't support files that already have opt-in
        assert(code != 92) # tool doesn't support signed SWFs

        if state == state_lookingForFileAttributes and tag == 69:
            state = state_lookingForMetadata
        elif state == state_lookingForMetadata:
            if tag == 77:
                state = state_gotMetadata
            else:
                outputTelemetryTag(o, passwordClear)
                state = state_done

        output(o,  rh)

        if length == 0x3f:
            ll = f.read(4)
            longlength = struct.unpack("BBBB", ll)
            length = ((longlength[3]&0xff) << 24) | ((longlength[2]&0xff) << 16) | ((longlength[1]&0xff) << 8) | (longlength[0]&0xff)
            bhead += 4
            output(o,  ll)

        output(o,  f.read(length))

        if state == state_gotMetadata:
            outputTelemetryTag(o,  passwordClear)
            state = state_done            

    ln = o.tell()
    o.seek(4)
    o.write(struct.pack("I", ln)) # fix up the length
    o.flush()
    o.close()
    
    if passwordClear:
        print("Added opt-in flag with encrypted password " + passwordClear)
    else:
        print("Added opt-in flag with no password")
