import '../styles/globals.css'
import { Header } from '../components/Header';
import { Footer } from '../components/Footer';
import { Provider } from '../utils/context';


function MyApp({ Component, pageProps }) {
  return (
    <div>
      <Provider >
        <Header />
        <Component {...pageProps} />
        <Footer />
      </Provider>
    </div>
  );
}

export default MyApp
