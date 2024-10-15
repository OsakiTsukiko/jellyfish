import * as monaco from 'monaco-editor';
import { shikiToMonaco } from '@shikijs/monaco'
import { createHighlighter } from 'shiki'

import { MultiButton } from './multi_button';

import { config } from './config';
import { init } from './initialization';

var editor: monaco.editor.IStandaloneCodeEditor = undefined;
export function getEditor(): monaco.editor.IStandaloneCodeEditor {
    return editor;
}

window.onload = async () => {
    init();
    
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