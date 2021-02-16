%%raw(`
import './index.css';
`)

@module("./reportWebVitals") external reportWebVitals: unit => unit = "default"

let rootElement = ReactDOM.querySelector("#root")

switch rootElement {
| Some(element) => ReactDOM.render(<React.StrictMode> <App /> </React.StrictMode>, element)
| None => ()
}

reportWebVitals()
