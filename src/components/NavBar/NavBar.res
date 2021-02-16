%%raw(`
import "./NavBar.css";
`)

@react.component
let make = () => {
  <div className="navbar"> <a> {"ReScript Hacker News"->React.string} </a> </div>
}
