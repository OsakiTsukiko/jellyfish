let dialogues: Array<Dialogue> = [];

export class Dialogue {
    id: String;
    element: HTMLElement;

    constructor(id: String, element: HTMLElement) {
        this.id = id;
        this.element = element;
    }

    static registerDialogue(d: Dialogue) {
        dialogues.push(d);
    }

    static hideDialogues() {
        for (let d of dialogues) {
            d.element.classList.add("hidden");
        }
    }

    static showDialogue(id: String) {
        for (let d of dialogues) {
            if (d.id == id) {
                d.element.classList.remove("hidden");
            } else {
                d.element.classList.add("hidden");
            }
        }
    }
};