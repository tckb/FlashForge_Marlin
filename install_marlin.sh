#!/bin/bash

# Created by argbash-init v2.10.0
# ARG_POSITIONAL_SINGLE([machine],[Choose the printer type; available options: dreamer_nx,dreamer,inventor])
# ARG_OPTIONAL_SINGLE([release-version],[],[Select one of the release versions on the github; ])
# ARG_OPTIONAL_BOOLEAN([restore-ff-firmware],[],[Restores one of the latest flashforge firmware, downloaded by Flashprint; this option proceeds release-version])
# ARG_OPTIONAL_BOOLEAN([verbose],[],[Turn on verbose mode],[])
# ARG_DEFAULTS_POS()
# ARG_HELP([Flash Marlin firmware],[Script to download & flash marlin directly to the printer])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='h'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_machine=
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_release_version=
_arg_restore_ff_firmware="off"
_arg_verbose="off"


print_help()
{
	printf '%s\n' "Flash Marlin firmware"
	printf 'Usage: %s [--release-version <arg>] [--(no-)restore-ff-firmware] [--(no-)verbose] [-h|--help] <machine>\n' "$0"
	printf '\t%s\n' "<machine>: Choose the printer type; available options: dreamer_nx,dreamer,inventor"
	printf '\t%s\n' "--release-version: Select one of the release versions on the github;  (no default)"
	printf '\t%s\n' "--restore-ff-firmware, --no-restore-ff-firmware: Restores one of the latest flashforge firmware, downloaded by Flashprint; this option proceeds release-version (off by default)"
	printf '\t%s\n' "--verbose, --no-verbose: Turn on verbose mode (off by default)"
	printf '\t%s\n' "-h, --help: Prints help"
	printf '\n%s\n' "Script to download & flash marlin directly to the printer"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			--release-version)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_release_version="$2"
				shift
				;;
			--release-version=*)
				_arg_release_version="${_key##--release-version=}"
				;;
			--no-restore-ff-firmware|--restore-ff-firmware)
				_arg_restore_ff_firmware="on"
				test "${1:0:5}" = "--no-" && _arg_restore_ff_firmware="off"
				;;
			--no-verbose|--verbose)
				_arg_verbose="on"
				test "${1:0:5}" = "--no-" && _arg_verbose="off"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	local _required_args_string="'machine'"
	test "${_positionals_count}" -ge 1 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 1 (namely: $_required_args_string), but got only ${_positionals_count}." 1
	test "${_positionals_count}" -le 1 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 1 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_machine "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


PRINTER_TYPE="$_arg_machine"
RELEASE_VERSION="$_arg_release_version"
BUILD_DIR="$PWD/BUILD"
FLASHING_SCRIPT="$PWD/ff_flash_firmware.py"
RELEASE_NAME="marlin_${PRINTER_TYPE}"
TARGET_RELEASE_NAME="${RELEASE_NAME}_v${RELEASE_VERSION}.bin"
FLASHFORGE_MARLIN_RELEASE_URL="https://github.com/tckb/FlashForge_Marlin/releases/download/v${RELEASE_VERSION}/${RELEASE_NAME}.bin"
FINAL_FW=""

# firmware search paths for flashforge
OSX_FF_FW_PATH="$HOME/.FlashPrint/firmware2.00"
LINUX_FF_FW_PATH=""
# helper functions
function __msg_error() {
    [[ "${ERROR}" == "1" ]] && echo -e "[ERROR]: $*"
}

function __msg_debug() {
    [[ "${DEBUG}" == "1" ]] && echo -e "[DEBUG]: $*"
}

function __msg_info() {
    [[ "${INFO}" == "1" ]] && echo -e "[INFO]: $*"
}


# log levels
ERROR=1
if [ $_arg_verbose = on ]
then
   DEBUG=1
else
   DEBUG=0
fi
INFO=1


if [ -z $_arg_release_version  ] && [ $_arg_restore_ff_firmware = off ]
  then
     __msg_error "expecting either a valid release version --release-version <0.7> or --restore-ff-firmware"
     exit 1
fi

function download_marlin_release() {
  FINAL_FW="${BUILD_DIR}/${TARGET_RELEASE_NAME}"

  if [ ! -f "${FINAL_FW}" ]; then
    __msg_info "Downloading FlashForge Marlin for ${PRINTER_TYPE} v${RELEASE_VERSION}"

    if [ $_arg_verbose = on ]
    then
      wget  "${FLASHFORGE_MARLIN_RELEASE_URL}" -O "${FINAL_FW}"
    else
      wget -q "${FLASHFORGE_MARLIN_RELEASE_URL}"  -O "${FINAL_FW}" 2> /dev/null
    fi

    if [ $? != 0 ]; then
      __msg_error "release does not exist, exiting..."
      exit 1
    fi

  fi
}

function search_flashforge_firmware() {
  __msg_info "Searching for flashforge firmware for ${PRINTER_TYPE}; Make sure you've install Flashprint"

  machine_name=""

  case "${PRINTER_TYPE}" in
    dreamer_nx)
       machine_name="Dreamer Nx"
       ;;
    dreamer)
        machine_name="Dreamer"
        ;;
    inventor)
        machine_name="Inventor"
        ;;
    *)
      __msg_error Unknown or unsupported machine, only dreamer, dreamer_nx & inventor are supported
        exit 1
        ;;
  esac

  fm_dir=""

  case "$OSTYPE" in
    darwin*)
      fm_dir="${OSX_FF_FW_PATH}/FlashForge ${machine_name}"
       ;;
    linux*)
        __msg_error Linux is not currently supported, yet.
        exit 0
        ;;
    *)
      __msg_error Unsupported platform
        exit 1
        ;;
  esac

  ff_fmw=$(find "${fm_dir}"  -name  "*.bin" | head -1  2>/dev/null)

   if [ $? -eq 0 ]; then
      if [ ! -z  "${ff_fmw}" ]; then
          fmw=$(basename "${ff_fmw}")
          __msg_info "Found ${fmw} !"

          read  -n 1 -p "Continue flashing? Cntrl+c to exit"
          cp "${ff_fmw}" "${BUILD_DIR}/${fmw}"
          FINAL_FW="${BUILD_DIR}/${fmw}"

        else
          __msg_error "No firmware found at ${fm_dir}!, Did you try 'firmware update' on FlashPrint?"
          exit 0
      fi
    else
        __msg_error "${fm_dir} doesn't to exist, Did you try 'firmware update' on FlashPrint?"
          exit 1
  fi

}


function flash_firmware() {
  __msg_info "Flashing ${FINAL_FW}"

  if [ $1 -eq 0 ]; then
      ${FLASHING_SCRIPT} ${FINAL_FW} False
    else
      ${FLASHING_SCRIPT} ${FINAL_FW} True
  fi

}

function main() {
  mkdir -p "${BUILD_DIR}"

  if [ $_arg_restore_ff_firmware = on ]
  then
     __msg_info "Restoring to stock flashforge firmware..."
     search_flashforge_firmware
     flash_firmware 1

  else
    download_marlin_release
    flash_firmware 0
  fi
}

# Run main
main


# ] <-- needed because of Argbash
