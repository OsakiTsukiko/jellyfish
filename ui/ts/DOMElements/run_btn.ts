import { getEditor } from "..";
import { MultiButton } from "../multi_button";
import { comp_arg } from "./comp_arg_dialogue";

export function init_run_btn() {
    let compile_and_run_button = document.getElementById("run-button")!;
    compile_and_run_button.onclick = () => {
        let value = getEditor().getValue();
        // @ts-ignore WEBUI
        runZig(value, comp_arg);
    }
    let compile_button = document.getElementById("build-button")!;
    
    var compile_multibutton = new MultiButton(
        compile_and_run_button, 
        [
            compile_button,
        ]
    );
}