mod SomeModule {
    macro_rules!getLine{()=>{{let mut s=String::new();std::io::stdin().read_line(&mut s);s}};}
    macro_rules!read{($x:expr)=>{$x.parse().unwrap()};}
    macro_rules!reads{($x:expr)=>{{for(i, x)in getLine!().trim().split(' ').enumerate(){$x[i]=read!(x);}$x}};}
}
