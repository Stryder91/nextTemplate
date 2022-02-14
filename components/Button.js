export const Btn = ({ cb, text="Click here", cn="py-1 px-3" }) => {
	return(
		<div>
			<button onClick={cb} className={`btn ${cn}`}>{text}</button>
		</div>
	);    
}