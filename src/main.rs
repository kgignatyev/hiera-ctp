extern crate reqwest;
extern crate serde_json;
extern crate base64;


use std::io::{Read, Error};
use std::env;
use serde_json::{ Value};




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
//    let mut res = reqwest::get("http://httpbin.org/get")?;
    let url = format!("http://localhost:8500/v1/kv/{}", path);
    println!("trying:{}", url);

    let mut res = reqwest::get(&url)?;
    let mut body = String::new();
    res.read_to_string(&mut body)?;

    println!("Status: {}", res.status());
    println!("Headers:\n{:#?}", res.headers());
    println!("Body:\n{}", body);
    if res.status() == 200 {
        Ok(body)
    } else {
        Err(CustomError::Info("no value".to_string()))
    }
}


fn find_key_value(key: &String, path_parts: &[String])->Option<String> {
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
                Ok(x) => {println!("OK: got - {}", x);res = Some(x);},
                Err(_) => println!("Error")
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
            let r:Result<Value,serde_json::Error> = serde_json::from_str(&data);
            match r {
                Ok(v) => {
                    let b64v = v[0]["Value"].to_string();
                    let vd =  base64::decode( &b64v).unwrap();

                    let s = String::from_raw_parts(vd).unwrap();


                    println!("OK: got key - {} = {} = {}",v[0]["Key"],b64v, s);
                },
                Err(err) => {}
            }
        },
        None =>{

        }
    }

    println!("{:?}", args);
//    run();
}
