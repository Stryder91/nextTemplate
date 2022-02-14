import Image from 'next/image';

import twitter_logo from '../public/twitter.svg'
import discord_logo from '../public/discord.svg'
import instagram_logo from '../public/instagram.svg'

export const MediaBadge = ({ frame_class }) => {
	const medias = [
		{
			name: "Discord",
			src: discord_logo,
		},
		{
			name: "Twitter",
			src: twitter_logo,
		},
		{
			name: "Instagram",
			src: instagram_logo,
		},
	];
	
	return(
		<div className={`mx-4 flex justify-center items-center ${frame_class}`}>
			{medias.map((m,i) => {
				return <div key={i} className="mr-3">
					<Image
						className='grow'
						src={m.src}
						alt={`${m.name} logo`}
						width={30}
						height={22}
					/>
				</div>
			})}
		</div>
	);
}