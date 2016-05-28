mod SomeModule {
    macro_rules!getLine{()=>{{let mut s=String::new();std::io::stdin().read_line(&mut s);s}};}
}
