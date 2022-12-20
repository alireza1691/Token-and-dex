import Link from "next/link";
import { useEffect } from "react";
import {useRouter} from 'next/router'
import Header from '../components/Header'
import Footer from '../components/footer'
import styles from '../styles/Home.module.css'

const NotFound = () => {
    const router = useRouter();

    useEffect (() => {
        setTimeout(() => {

        }, 3000)
    }, [])

    return (
        <div className={styles.container}>
        <Header/>
        <div className={styles.main}>
        <div className="'not-found">
            <h1>Oooops</h1>
            <h2>That page cannot be found.</h2>
            <p>Go back to the <Link href={'/'}>Home page</Link></p>
        </div>
        </div>
        </div>
    )

}
export default NotFound;