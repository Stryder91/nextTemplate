import Link from 'next/link'
import Image from 'next/image'

// import logo from '../public/logo.svg'

export const NavHeader = ({ routes }) => {

	return(
		<div className='flex'>
			<Link href='/'>
				<div className='mr-10 cursor-pointer'>
					{/* <Image
						src={logo}
						alt="Nefty Seven logo"
						width={60}
						height={60}
						className='grow'
					/> */}
				</div>
			</Link>
			<div className='flex justify-center items-center'>
				{routes.map((r,i) => {
					return <Link key={i} href={r.path}>
						<a className='mr-5'> {r.name} </a>
					</Link>
				})}
			</div>
		</div>
	);
}