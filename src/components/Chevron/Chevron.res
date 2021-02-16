module Down = {
  @react.component
  let make = () => {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="18"
      height="18"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className="feather feather-chevron-down">
      <polyline points="6 9 12 15 18 9" />
    </svg>
  }
}

module Right = {
  @react.component
  let make = () => {
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="18"
      height="18"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className="feather feather-chevron-right">
      <polyline points="9 18 15 12 9 6" />
    </svg>
  }
}
