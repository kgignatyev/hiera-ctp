extern crate reqwest;
extern crate serde_json;

use std::io::Read;

use std::io::{Error,ErrorKind};
use std::env;



fn get_key_value(path: &String) -> Result<String,Error> {
//    let mut res = reqwest::get("http://httpbin.org/get")?;
    let url = format!( "http://localhost:8500/v1/kv/{}", path);
    println!("trying:{}",url);

    let mut res = reqwest::get(&url)?;
    let mut body = String::new();
    res.read_to_string(&mut body)?;

    println!("Status: {}", res.status());
    println!("Headers:\n{:#?}", res.headers());
    println!("Body:\n{}", body);
    if res.status() == 200 {
        Ok(body)
    } else {
        Err(Error::new( ErrorKind::NotFound ,""))
    }
}


fn find_key_value(key: &String, path_parts: &[String]) {
    let mut parts = path_parts.to_vec();
    parts.reverse();
    let path = format!( "{}/{}", parts.join("/") , key);
    let r = get_key_value( &path );
    match r {
        Ok(x)  => println!("OK: got - {}",x),
        Err(_) => println!("Error")
    }

    
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let (left, path_parts) = args.split_at(2);
    let key = left.get(1).unwrap();
    let res = find_key_value(&key, &path_parts);
    println!("{:?}", args);
//    run();
}
