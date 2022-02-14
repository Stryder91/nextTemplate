import { MediaBadge } from './MediaBadge'
import { ConnectMetamask } from './Metamask'
import { NavHeader } from './NavHeader'
import { DDown } from './Dropdown'


export const Header = () => {
	const routes = [
		{
			name: "Roadmap",
			path: "#road",
		},
		{
			name: "F.A.Q",
			path: "#faq",
		},
		{
			name: "Infos",
			path: "/infos",
		},
		{
			name: "Mint",
			path: "/mint",
		},
	];

	return(
		<header className="header">
			<NavHeader routes={routes}/>
			<div className='lg:flex'>
				<div className='lg:hidden'>
					<DDown onlyMobile={true} routes={routes} />
				</div>
				<div className='hidden lg:block lg:flex'>
					<MediaBadge />
					<ConnectMetamask />
				</div>
			</div>
		</header>
	);
}