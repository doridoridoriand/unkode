#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;
#[macro_use] extern crate rocket_contrib;
#[macro_use] extern crate serde_derive;
extern crate uuid;

use std::sync::Mutex;
use std::collections::HashMap;

use uuid::Uuid;
use rocket_contrib::json::{Json, JsonValue};

#[derive(Serialize, Deserialize)]
struct ResponseJson {
    uuid: String
}

#[get("/", format = "json")]
fn res_uuid() -> JsonValue {
    let my_uuid = Uuid::new_v4();
    let my_uuid_str: &str = &my_uuid.to_string();
    json!(ResponseJson {uuid: my_uuid_str})
}

fn main() {
    let my_uuid = Uuid::new_v4();
    println!("{}", my_uuid);
    rocket::ignite().mount("/", routes![res_uuid]).launch();
}
