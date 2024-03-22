extern crate reqwest;
#[macro_use]
extern crate serde_derive;
extern crate serde;
extern crate serde_json;
extern crate base64;
extern crate state;

mod err;

use std::io::Read;
use std::env;
//use serde_json::Value;
//use serde::Deserialize;
use base64::decode;
use err::CTPError;
use reqwest::blocking::Client;
use state::InitCell;


struct ConsulConnectionState {
    http_client: Client,
    base_url: String,
    token: String,
}

static CONSUL_CONN: InitCell<ConsulConnectionState> = InitCell::new();

#[allow(non_snake_case)]
#[derive(Debug, Deserialize)]
struct KeyData {
    Key: String,
    Value: String,
}


fn get_key_value(path: &String) -> Result<String, CTPError> {
    let cconn = CONSUL_CONN.get();
    let url: String = format!("{}/v1/kv/{}", cconn.base_url, path);
    let mut request_builder =  cconn.http_client.get(&url);
    if cconn.token.len() != 0 {
        request_builder = request_builder.header("X-Consul-Token", cconn.token.to_string());
    }
    let mut res = request_builder.send().unwrap();

    if res.status() == 200 {
        let mut body = String::new();
        res.read_to_string(&mut body)?;
        let r: Result<Vec<KeyData>, serde_json::Error> = serde_json::from_str(&body);
        match r {
            Ok(v) => {
                let b64v = v[0].Value.as_str();
                let vd = decode(b64v).unwrap();
                let s = String::from_utf8(vd).unwrap();
                Ok(s)
            }
            Err(_) => Err(CTPError::Info("no value".to_string()))
        }
    } else {
        Err(CTPError::Info("no value".to_string()))
    }
}


fn find_key_value(key: &String, path_parts: &[String]) -> Option<String> {
    let mut parts = path_parts.to_vec();
    parts.reverse();
    let mut res: Option<String> = None;
    let length = parts.len();
    for x in 0..length {
        if res.is_none() {
            let (head, _tail) = parts.split_at(length - x);
            let path = format!("{}/{}", head.join("/"), key);
            let r = get_key_value(&path);
            match r {
                Ok(x) => {
                    res = Some(x)
                }
                Err(_e) => {}
            }
        }
    }
    res
}

fn main() {
    let httpc = Client::new();
    let base = env::var("CONSUL_HTTP_ADDR").unwrap_or_else(|_| "http://localhost:8500".to_string());
    let t = env::var("CONSUL_HTTP_TOKEN").unwrap_or_else(|_| "".to_string());

    let ccon = ConsulConnectionState {
        http_client: httpc,
        base_url: base,
        token: t,
    };


    CONSUL_CONN.set(ccon);
    let args: Vec<String> = env::args().collect();
    let (left, path_parts) = args.split_at(2);
    let key = left.get(1).unwrap();
    let res = find_key_value(&key, &path_parts);
    match res {
        Some(data) => {
            println!("{}", data)
        }
        None => {
            let default_path = format!("default/{}", key);
            let default_res = get_key_value(&default_path);
            match default_res {
                Ok(s) => println!("{}", s),
                Err(_) => println!("null")
            }
        }
    }
}
