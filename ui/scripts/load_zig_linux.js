import { $ } from "bun";

const zig_url = `https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz`;

const download_folder = `../zig-out/download/zig/linux`;
const bin_folder = `../zig-out/bin/zig/linux`;

await $`mkdir -p ${bin_folder}`
await $`mkdir -p ${download_folder}`

await $`wget -O ${download_folder}/z.tar.xz ${zig_url}`
await $`tar -xf ${download_folder}/z.tar.xz -C ${download_folder}/`
await $`mv ${download_folder}/zig*/* ${bin_folder}`

await $`rm -r ${download_folder}`