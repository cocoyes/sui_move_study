import { loadSync as loadEnvSync } from "https://deno.land/std/dotenv/mod.ts"
import { Ed25519Keypair, fromB64 } from 'npm:@mysten/sui.js';


const env = loadEnvSync();
const PRIVATE_KEY_SIZE = 32;
const secret_key_base64 = env.SECRET_KEY_ED25519_1_B64;
const raw = fromB64(secret_key_base64);
// The ed25519 flag is 0x00. See more at https://docs.sui.io/learn/cryptography/sui-signatures
if (raw[0] !== 0 || raw.length !== PRIVATE_KEY_SIZE + 1) {
    throw new Error('invalid key');
}
const keypair = Ed25519Keypair.fromSecretKey(raw.slice(1));
console.log(keypair.getPublicKey().toSuiAddress())
