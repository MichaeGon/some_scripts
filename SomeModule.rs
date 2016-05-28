mod SomeModule {
    macro_rules!getLine{()=>{{let mut s=String::new();std::io::stdin().read_line(&mut s);s}};}
    macro_rules!read{()=>{getLine!().trim().parase.unwrap()};($x:expr)=>{for(i,x)in getLine!().trim().split(' ').enumerate(){$x[i]=x.parse().unwrap()}};}
}
