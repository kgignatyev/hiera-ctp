

pub enum CTPError {
    Io(std::io::Error),
    Reqwest(reqwest::Error),
    Info(String),
}

impl From<std::io::Error> for CTPError {
    fn from(err: std::io::Error) -> CTPError {
        CTPError::Io(err)
    }
}

impl From<reqwest::Error> for CTPError {
    fn from(err: reqwest::Error) -> CTPError {
        CTPError::Reqwest(err)
    }
}

impl From<String> for CTPError {
    fn from(err: String) -> CTPError {
        CTPError::Info(err)
    }
}
