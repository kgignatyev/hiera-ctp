extern crate reqwest;
extern crate serde_json;
extern crate base64;


use std::io::{Read, Error};
use std::env;
use serde_json::Value;
use base64::{decode};


enum CustomError {
    Io(std::io::Error),
    Reqwest(reqwest::Error),
    Info(String),
}

impl From<std::io::Error> for CustomError {
    fn from(err: std::io::Error) -> CustomError {
        CustomError::Io(err)
    }
}

impl From<reqwest::Error> for CustomError {
    fn from(err: reqwest::Error) -> CustomError {
        CustomError::Reqwest(err)
    }
}

impl From<String> for CustomError {
    fn from(err: String) -> CustomError {
        CustomError::Info(err)
    }
}


fn get_key_value(path: &String) -> Result<String, CustomError> {
    let url: String = format!("http://localhost:8500/v1/kv/{}", path);
//    println!("trying:{}", url);

    let mut res = reqwest::get(&url)?;
    let mut body = String::new();
    res.read_to_string(&mut body)?;
    if res.status() == 200 {
        let r: Result<Value, serde_json::Error> = serde_json::from_str(&body);
        match r {
            Ok(v) => {
                let b64v = v[0]["Value"].as_str().unwrap();
                let vd = decode(b64v).unwrap();
                let s = String::from_utf8(vd).unwrap();
                Ok(s)
            }
            Err(_) => Err(CustomError::Info("no value".to_string()))
        }
    } else {
        Err(CustomError::Info("no value".to_string()))
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
    let args: Vec<String> = env::args().collect();
    let (left, path_parts) = args.split_at(2);
    let key = left.get(1).unwrap();
    let mut res = find_key_value(&key, &path_parts);
    match res {
        Some(data) => {
            res = Some(data);
        }
        None => {
            let default_path = format!("default/{}",key );
            let default_res = get_key_value(&default_path);
            res = match default_res {
                Ok( s) =>  Some(s),
                Err(_)=> None
            }
        }
    }

    match res {
        Some(v)=> println!("{}",  v),
        None=>println!("null")
    }
    
}
