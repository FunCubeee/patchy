# patchy — MTK kernel cleaner

**patchy** is a Magisk module that helps old MediaTek phones (with kernel >4.14) run newer GSI ROMs without losing internet. The problem is often leftover firewall crap inside the kernel. patchy finds those strings and zeroes them out.

## How it works (the short version)

- You press the **ACTION** button in Magisk Manager
- Pick your `boot.img`
- The module unpacks, patches the kernel, and repacks the image
- Done file lands in your `Download` folder

## Requirements

- Magisk installed (28+ recommended)
- Your `boot.img` (stock or already Magisk-patched) – put it in `/sdcard`
- A bit of patience 🙂

## Installation

1. Grab the latest ZIP from [releases](https://github.com/FunCubeee/patchy/releases)
2. Open Magisk Manager → Modules → Install from storage
3. Select the downloaded ZIP
4. Reboot

## How to use

1. Copy `boot.img` to your internal storage (`/sdcard`)
2. Open Magisk → Modules → tap **ACTION** next to `patchy`
3. If multiple `.img` files are found – **Volume Up** to scroll, **Volume Down** to select
4. Wait for `SUCCESS` message
5. Patched image will be at `/sdcard/Download/bpfpatched_timestamp.img`
6. Flash it via fastboot or within Magisk (as you usually do)

## Where the binary comes from

Inside the module there's a tiny ARM64 binary (~50 KB) that does the actual patching. It's compiled from [R0rt1z2/mtk-bpf-patcher](https://github.com/R0rt1z2/mtk-bpf-patcher) using Cython. No Python needed on your phone.


## License

MIT – do whatever you want, just keep the credits.

---

### Something went wrong?

Check the log: `/data/local/tmp/kernel_patcher/action.log`

It tells you exactly where the script failed. Paste it in issues, I'll help.
