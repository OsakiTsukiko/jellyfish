export class MultiButton {
    main_button: HTMLElement;
    other_buttons: Array<HTMLElement> = [];
    toggle: boolean = false;

    onmousedown(event: MouseEvent) {
        if (event.buttons == 2) {
            event.stopPropagation();

            this.toggle = !this.toggle;
            for (let btn of this.other_buttons) {
                if (this.toggle) {
                    btn.classList.remove("hidden");
                } else {
                    btn.classList.add("hidden");
                }
            }
        }
    }

    constructor(main_button: HTMLElement, other_buttons :Array<HTMLElement>) {
        this.main_button = main_button
        this.other_buttons = other_buttons

        this.main_button.onmousedown = this.onmousedown.bind(this);
    }
};