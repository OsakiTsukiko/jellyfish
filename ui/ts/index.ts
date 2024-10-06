import * as monaco from 'monaco-editor';
import { MultiButton } from './multi_button';

monaco.editor.create(document.getElementById('editor')!, {
	value: ['function x() {', '\tconsole.log("Hello world!");', '}'].join('\n'),
	language: 'javascript',
    theme: 'vs-dark',
    automaticLayout: true,
});

window.onload = () => {
    document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
    });
    
    let compile_and_run_button = document.getElementById("compile-and-run-button")!;
    let compile_button = document.getElementById("compile-button")!;
    let run_button = document.getElementById("run-button")!;
    
    var compile_multibutton = new MultiButton(
        compile_and_run_button, 
        [
            compile_button,
            run_button,
        ]
    );
}