import { getEditor } from ".";
import { getCompArg, getPRW, setCompArg, setPRW } from "./DOMElements/comp_arg_dialogue";

export const DEFAULT_ZIG = `const std = @import("std");

pub fn main() void {
    std.debug.print("Hello, {s}!\\n", .{"World"});
}
`;

export const CONFIG_FILE = "config.jlf"

interface IConfig {
    code: string;
    comp_arg: string;
    pre_run_wrapper: string;
  } 

export function getConfig(): String {
    let config = {
        code: getEditor().getValue(),
        comp_arg: getCompArg(),
        pre_run_wrapper: getPRW(),
    };

    return JSON.stringify(config);
}

export function setConfig(json: String) {
    let config_o: Object = JSON.parse(json.toString());
    if (
        !config_o.hasOwnProperty("code") || 
        !config_o.hasOwnProperty("comp_arg") || 
        !config_o.hasOwnProperty("pre_run_wrapper")
    ) {
        console.error("ERROR LOADING CONFIG, INVALID JSON!");
        return;
    }

    let config = config_o as IConfig;
    getEditor().setValue(config.code);
    setCompArg(config.comp_arg);
    setPRW(config.pre_run_wrapper);
}