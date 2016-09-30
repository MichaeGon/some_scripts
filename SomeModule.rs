use std::io;

mod SomeModule {
    fn get_line() -> String {
        let mut s = String::new();
        io::stdin().read_line(&mut s).ok();
        s
    }
}
