import Head from 'next/head'
import Image from 'next/image'
import styles from '../styles/Home.module.css'
import 'bulma/css/bulma.css'
import Link from 'next/link'

export default function Home() {
  return (
    <div className={styles.container}>
      <Head>
        <title>Invesweet Pool</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <div className='box'>
          <nav className='level navbar-has-shadow py-1'>
            <div className='navbar-brand'>
              <h1>Invesweet</h1>
            </div>
            <div className='navbar-end'>
              <div className='navbar-item'>
                <button className='button is-link'>Connect Wallet</button>
              </div>
            </div>
          </nav>
        </div>

      <main className={styles.main}>
        <div className='box'>
          <div class="tabs  is-centered ">
            <ul className=''>
              <li><Link href='/swap'>Swap</Link></li>
              <li class="is-active"><a>Pool</a></li>
            </ul>
          </div>
                <div className='box'>
                <label className="label">Deposit liquidity</label>
                <div className="control">
                    <div className="navbar-item is-hoverable navbar-end ">
                    </div>
                    <input className="input mt-2" value={""} type="text" placeholder="Input USDC amount..." onChange={(e) => setInputvalue1(e.target.value)} />
                    <input className="input mt-2" value={""} type="text" placeholder="Input IST amount..." onChange={(e) => setInputvalue1(e.target.value)} />
                    <button className='button is-link mt-2 mr-2'>Approve</button>
                    <button className='button is-link mt-2' disabled>Deposit</button>
                </div>
                </div>
                <div className='box'>
                <label className="label">Withdraw liquidity</label>
                <div className="control">
                    <div className="navbar-item is-hoverable navbar-end ">
                    </div>
                    <input className="input mt-2" value={""} type="text" placeholder="Input USDC amount..." onChange={(e) => setInputvalue1(e.target.value)} />
                    <input className="input mt-2" value={""} type="text" placeholder="Input IST amount..." onChange={(e) => setInputvalue1(e.target.value)} />
                    <button className='button is-link mt-2 mr-2'>Approve</button>
                    <button className='button is-link mt-2' disabled>Withdraw</button>
                </div>
                </div>
        </div>
      </main>

      <footer className={styles.footer}>
        <a
          href="https://vercel.com?utm_source=create-next-app&utm_medium=default-template&utm_campaign=create-next-app"
          target="_blank"
          rel="noopener noreferrer"
        >
          Powered by{' '}
          <span className={styles.logo}>
            <Image src="/vercel.svg" alt="Vercel Logo" width={72} height={16} />
          </span>
        </a>
      </footer>
    </div>
  )
}