import { useState } from 'react';
import { useRouter } from "next/router";

const textContent = {
  "fr-FR": {
    title: "FAQ",
    content: [
			 { 
				data: [
					{
						question: "Qui sommes-nous ?",
						answer: "Nefty seveeeeeeeeeen"
					}, 
					{
						question: "Où allons-nous ?",
						answer : "Je ne sais pas!!!!!!!!!"
					},
					{
						question: "Comment installer Metamask ?",
						answer: "Nefty seveeeeeeeeeen"
					}, 
					{
						question: "Sur quelle blockchain sont mintés mes NFT ?",
						answer: "Nefty seveeeeeeeeeen"
					}, 
				]
			}	
		]
		
  },
  "en-US": {
    title: "FAQ",
		content: [
			{ 
				data: [
					{
						question: "Who are us ?",
						answer: "Nefty seveeeeeeeeeen"
					}, 
					{
						question: "AAAAAAA",
						answer : "Je ne sais pas!!!!!!!!!"
					},
					{
						question: "How to install Metamask ?",
						answer: "Nefty seveeeeeeeeeen"
					}, 
					{
						question: "Sur quelle blockchain sont mintés mes NFT ?",
						answer: "Nefty seveeeeeeeeeen"
					}, 
				]
			}	
		]
  },
};

export const Faq = () => {

	const { locale, locales, defaultLocale, asPath } = useRouter();
  const { title, content } = textContent[locale];
  
	const [active, setActive] = useState(null);

	return(
			<div className="container white mt-20" id="faq">
			<h1 className="py-4 text-left hero-title">{title}</h1>
			{content.map((items, i) => (
				<div className="dropdown-frame mb-10">
					{items.data.map((d, i) => {
						return <div key={i} className="dropdown my-4">
							<p onClick={ () => setActive(i+1)} className="text-left dropdown dropdown-banner ">{d.question}</p>
							<div className={active && active == i+1 ? "dropdown-content" : "hidden"}>
								<p>{d.answer}</p>
							</div>
						</div>
					})}
				</div>
			))}
		</div>
	);
}