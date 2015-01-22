# Copyright (C) 2012 The Android Open Source Project
# Copyright (C) 2014 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Custom OTA commands for find7 devices"""

def FullOTA_InstallEnd(info):
    info.script.AppendExtra('ui_print("...Flashing Firmware...");')
    info.script.AppendExtra('ifelse((sha1_check(read_file("EMMC:/dev/block/platform/msm_sdcc.1/by-name/aboot:397536:5462be10598f4639f1e80398f73b450bcc827109")) != ""),(ui_print("/dev/block/platform/msm_sdcc.1/by-name/aboot already up to date")),(package_extract_file("system/temp/emmc_appsboot.mbn", "/dev/block/platform/msm_sdcc.1/by-name/aboot")));')
    info.script.AppendExtra('ifelse((sha1_check(read_file("EMMC:/dev/block/platform/msm_sdcc.1/by-name/rpm:191524:fd193d0c63e82db6ac46ef9512c20fc59d7ee24c")) != ""),(ui_print("/dev/block/platform/msm_sdcc.1/by-name/rpm already up to date")),(package_extract_file("system/temp/rpm.mbn", "/dev/block/platform/msm_sdcc.1/by-name/rpm")));')
    info.script.AppendExtra('ifelse((sha1_check(read_file("EMMC:/dev/block/platform/msm_sdcc.1/by-name/LOGO:1265152:89f18c77d2f128cebf187dc7b7d4ec58bae04722")) != ""),(ui_print("/dev/block/platform/msm_sdcc.1/by-name/LOGO already up to date")),(package_extract_file("system/temp/logo.bin", "/dev/block/platform/msm_sdcc.1/by-name/LOGO")));')
    info.script.AppendExtra('ifelse((sha1_check(read_file("EMMC:/dev/block/platform/msm_sdcc.1/by-name/tz:329560:df3050b849f9ff58cad32326ceeb954b2ec8613e")) != ""),(ui_print("/dev/block/platform/msm_sdcc.1/by-name/tz already up to date")),(package_extract_file("system/temp/tz.mbn", "/dev/block/platform/msm_sdcc.1/by-name/tz")));')
    info.script.AppendExtra('ifelse((sha1_check(read_file("EMMC:/dev/block/platform/msm_sdcc.1/by-name/modem:58492416:271ac1d9672628a046ff6997f9f3c412684cdc1a")) != ""),(ui_print("/dev/block/platform/msm_sdcc.1/by-name/modem already up to date")),(package_extract_file("system/temp/NON-HLOS.bin", "/dev/block/platform/msm_sdcc.1/by-name/modem")));')
    info.script.AppendExtra('ifelse((sha1_check(read_file("EMMC:/dev/block/platform/msm_sdcc.1/by-name/oppostanvbk:10485760:da05ae66962aa6fa64e8a39de49e70f6795c41de")) != ""),(ui_print("/dev/block/platform/msm_sdcc.1/by-name/oppostanvbk already up to date")),(package_extract_file("system/temp/static_nvbk.bin", "/dev/block/platform/msm_sdcc.1/by-name/oppostanvbk")));')
    info.script.AppendExtra('ifelse((sha1_check(read_file("EMMC:/dev/block/platform/msm_sdcc.1/by-name/sbl1:280544:5a5072be6eee489a9e99caccbb2b2cb03713020c")) != ""),(ui_print("/dev/block/platform/msm_sdcc.1/by-name/sbl1 already up to date")),(package_extract_file("system/temp/sbl1.mbn", "/dev/block/platform/msm_sdcc.1/by-name/sbl1")));')
    info.script.AppendExtra('ui_print("...Clean Up...");')
    info.script.AppendExtra('delete_recursive("/system/temp");')

