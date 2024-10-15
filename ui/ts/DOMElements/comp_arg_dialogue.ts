import { Dialogue } from "../dialogue";

export var comp_arg: String = "";

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
}