import { ProgLang } from "..";

export function getDefaultForLang(lang: ProgLang): string {
    switch (lang) {
        case ProgLang.C:
            return "";
        case ProgLang.CPP:
            return "";
        case ProgLang.ZIG:
            return `const std = @import("std");

pub fn main() void {
    std.debug.print("Hello, {s}!\\n", .{"World"});
}`;
    }
}