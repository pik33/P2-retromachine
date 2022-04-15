dim a(128) as ubyte
dim b as ubyte pointer
declare a$ alias b as string

a(0)=65
b=@a
a(1)=0
print a$

a$="b"
print a(0)
