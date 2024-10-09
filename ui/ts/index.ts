import * as monaco from 'monaco-editor';
import { shikiToMonaco } from '@shikijs/monaco'
import { createHighlighter } from 'shiki'

import { MultiButton } from './multi_button';
import { getDefaultForLang } from './lang/defaults';

export enum ProgLang {
    C = 0,
    CPP = 1,
    ZIG = 2,
}

var editor: monaco.editor.IStandaloneCodeEditor = undefined;

window.onload = async () => {
    document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
    });
    
    let compile_and_run_button = document.getElementById("compile-and-run-button")!;
    compile_and_run_button.onclick = () => {
        let value = editor.getValue();
        // @ts-ignore
        compileAndRun(value);
    }
    let compile_button = document.getElementById("compile-button")!;
    let run_button = document.getElementById("run-button")!;
    
    var compile_multibutton = new MultiButton(
        compile_and_run_button, 
        [
            compile_button,
            run_button,
        ]
    );

    let intv = setInterval(() => {
        // @ts-ignore
        if (webui.isConnected()) {
            clearInterval(intv);
            // @ts-ignore
            switchLanguage(ProgLang.ZIG);
        }
    }, 250);

    const highlighter = await createHighlighter({
        themes: [
          'vitesse-dark',
          'vitesse-light',
          'dark-plus'
        ],
        langs: [
          'zig',
        ],
    });

    monaco.languages.register({ id: 'zig' });
    shikiToMonaco(highlighter, monaco);
    /* const editor = monaco.editor.create(document.getElementById('container'), {
        value: 'const a = 1',
        language: 'javascript',
        theme: 'vitesse-dark',
    }) */
}

function switchLanguage(language: ProgLang) {
    switch (language) {
        case ProgLang.C:
            break;
        case ProgLang.CPP:
            break;
        case ProgLang.ZIG:
            // @ts-ignore
            loadLanguage(ProgLang.ZIG);
            console.log("HELLO");
            editor = monaco.editor.create(document.getElementById('editor')!, {
                value: getDefaultForLang(language),
                language: 'zig',
                theme: 'dark-plus',
                automaticLayout: true,
            });
            break;
    }
}