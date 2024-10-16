import { Dialogue } from "../dialogue";
import { MultiButton } from "../multi_button";

var comp_arg: String = "";
export function getCompArg(): String {return comp_arg;}
export function setCompArg(ca: String) {comp_arg = ca;}
var pre_run_wrapper: String = "";
export function getPRW(): String {return pre_run_wrapper;}
export function setPRW(prw: String) {pre_run_wrapper = prw;}

export function init_comp_arg_dialogue() {
    let comp_arg_dialogue = new Dialogue("comp-arg", document.getElementById("comp-arg-dialogue")!);
    Dialogue.registerDialogue(comp_arg_dialogue);
    Dialogue.hideDialogues();
    let cad_inp: HTMLInputElement = document.getElementById("cad-inp")! as HTMLInputElement;
    let cad_btn: HTMLButtonElement = document.getElementById("cad-btn")! as HTMLButtonElement;
    cad_btn.onclick = () => {
        let val = cad_inp.value;
        comp_arg = val;
        Dialogue.hideDialogues();
    }

    let comp_arguments_button = document.getElementById("comp-arguments")!;
    comp_arguments_button.onclick = () => {
        cad_inp.value = comp_arg.toString();
        Dialogue.showDialogue("comp-arg");
    }

    let pre_run_wrapper_dialogue = new Dialogue("pre-run-wrapper", document.getElementById("pre-run-wrapper-dialogue")!);
    Dialogue.registerDialogue(pre_run_wrapper_dialogue);
    Dialogue.hideDialogues();
    let prw_inp: HTMLInputElement = document.getElementById("prw-inp")! as HTMLInputElement;
    let prw_btn: HTMLButtonElement = document.getElementById("prw-btn")! as HTMLButtonElement;
    prw_btn.onclick = () => {
        let val = prw_inp.value;
        pre_run_wrapper = val;
        Dialogue.hideDialogues();
    }

    let pre_run_wrapper_btn = document.getElementById("pre-run-wrapper")!;
    pre_run_wrapper_btn.onclick = () => {
        prw_inp.value = pre_run_wrapper.toString();
        Dialogue.showDialogue("pre-run-wrapper");
    }

    var compile_multibutton = new MultiButton(
        comp_arguments_button, 
        [
            pre_run_wrapper_btn,
        ]
    );
}