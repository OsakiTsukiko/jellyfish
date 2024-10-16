import { getEditor } from "..";
import { CONFIG_FILE, getConfig } from "../config";
import { MultiButton } from "../multi_button";
import { getCompArg, getPRW } from "./comp_arg_dialogue";

export function init_run_btn() {
    let compile_and_run_button = document.getElementById("run-button")!;
    compile_and_run_button.onclick = () => {
        // @ts-ignore
        saveConfig(CONFIG_FILE, getConfig());
        let value = getEditor().getValue();
        // @ts-ignore WEBUI
        runZig(value, getCompArg(), getPRW());
    }
    let compile_button = document.getElementById("build-button")!;
    
    var compile_multibutton = new MultiButton(
        compile_and_run_button, 
        [
            compile_button,
        ]
    );
}