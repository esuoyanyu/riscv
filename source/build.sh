#!/bin/bash

# $1-工具链 $2-平台 $3-输出目录
build_opensbi() {
	export CROSS_COMPILE=${1:-riscv64-linux-gnu-gcc}
	platform=${2:-generic}
	out=${3:-build}
	make CC=${CROSS_COMPILE} PLATFORM=$platform O=$out && make PLATFORM=$platform install
	if [ $? -neq 0 ]; then
		echo "build opensbi fail"
		return 1
	fi
}

# $1-bios $2-uboot $3-Image
run_qemu() {
	biso=${1:-build/fw_payload.bin}
	qemu-system-riscv64 -M virt -m 256m -nographic \
		-bios $biso
}

read -p "build opensbi or run qemu, input opensbi or qemu:" input

case "$input" in
	"opensbi")
		build_opensbi "clang"
	;;
	"qemu")
		run_qemu ""
	;;
	*)
		echo "usage: input opensbi or qemu"
	;;
esac
