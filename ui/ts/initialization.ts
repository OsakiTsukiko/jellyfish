import { init_comp_arg_dialogue } from "./DOMElements/comp_arg_dialogue";
import { init_run_btn } from "./DOMElements/run_btn";
import { MultiButton } from "./multi_button";

export function init() {
    document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
    });

    init_run_btn();
    init_comp_arg_dialogue();
}