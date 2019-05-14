

pub enum CustomError {
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
