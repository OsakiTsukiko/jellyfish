import * as monaco from 'monaco-editor';
import { shikiToMonaco } from '@shikijs/monaco'
import { createHighlighter } from 'shiki'

import { MultiButton } from './multi_button';

import { config } from './config';

var editor: monaco.editor.IStandaloneCodeEditor = undefined;

window.onload = async () => {
    document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
    });
    
    let compile_and_run_button = document.getElementById("compile-and-run-button")!;
    compile_and_run_button.onclick = () => {
        let value = editor.getValue();
        // @ts-ignore WEBUI
        runZig(value);
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
            // WEBUI LOADED
        }
    }, 250);

    const highlighter = await createHighlighter({
        themes: [
          'dark-plus'
        ],
        langs: [
          'zig',
        ],
    });

    monaco.languages.register({ id: 'zig' });
    shikiToMonaco(highlighter, monaco);
    
    editor = monaco.editor.create(document.getElementById('editor')!, {
        value: config.defaultZig,
        language: 'zig',
        theme: 'dark-plus',
        automaticLayout: true,
    });
}