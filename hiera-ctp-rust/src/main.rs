extern crate reqwest;
extern crate serde_json;
extern crate base64;

mod err;

use std::io::Read;
use std::env;
use serde_json::Value;
use base64::decode;
use err::CTPError;

fn get_key_value(path: &String) -> Result<String, CTPError> {
//    let url: String = format!("http://localhost:8500/v1/kv/{}", path);
    let mut url: String = "http://localhost:8500/v1/kv/".to_owned();
    url.push_str( path);
    let mut res = reqwest::get(&url)?;
    if res.status() == 200 {
        let mut body = String::new();
        res.read_to_string(&mut body)?;
        let r: Result<Value, serde_json::Error> = serde_json::from_str(&body);
        match r {
            Ok(v) => {
                let b64v = v[0]["Value"].as_str().unwrap();
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
            let  path = format!("{}/{}", head.join("/"), key);
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
    let args: Vec<String> = env::args().collect();
    let (left, path_parts) = args.split_at(2);
    let key = left.get(1).unwrap();
    let res = find_key_value(&key, &path_parts);
    match res {
        Some(data) => {
            println!("{}",  data)
        }
        None => {
            let default_path = format!("default/{}",key );
            let default_res = get_key_value(&default_path);
            match default_res {
                Ok( s) =>  println!("{}",  s),
                Err(_)=> println!("null")
            }
        }
    }
}
