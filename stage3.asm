
_stage3:     file format elf32-i386


Disassembly of section .text:

00000000 <handle_signal>:
#include "signal.h"
#
static int count = 0;

void handle_signal(siginfo_t info)
{	
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 10             	sub    $0x10,%esp
	count++;
   6:	a1 cc 0b 00 00       	mov    0xbcc,%eax
   b:	40                   	inc    %eax
   c:	a3 cc 0b 00 00       	mov    %eax,0xbcc
	if(count>=100000){
  11:	a1 cc 0b 00 00       	mov    0xbcc,%eax
  16:	3d 9f 86 01 00       	cmp    $0x1869f,%eax
  1b:	7e 2e                	jle    4b <handle_signal+0x4b>
	int* ptr = &(info.signum);
  1d:	8d 45 08             	lea    0x8(%ebp),%eax
  20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	int i;
	for(i=0; i<5; i++){
  23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  2a:	eb 0c                	jmp    38 <handle_signal+0x38>
	ptr+= (int)sizeof(&ptr)/4;
  2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2f:	83 c0 04             	add    $0x4,%eax
  32:	89 45 f8             	mov    %eax,-0x8(%ebp)
{	
	count++;
	if(count>=100000){
	int* ptr = &(info.signum);
	int i;
	for(i=0; i<5; i++){
  35:	ff 45 fc             	incl   -0x4(%ebp)
  38:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  3c:	7e ee                	jle    2c <handle_signal+0x2c>
	ptr+= (int)sizeof(&ptr)/4;
	}
	//printf(1, "Size of element: %d\n", (int)sizeof(&info.signum)*10);
	(*ptr) += (int)sizeof(&ptr)*5/4;	
  3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  41:	8b 55 f8             	mov    -0x8(%ebp),%edx
  44:	8b 12                	mov    (%edx),%edx
  46:	83 c2 05             	add    $0x5,%edx
  49:	89 10                	mov    %edx,(%eax)
	}
		
}
  4b:	c9                   	leave  
  4c:	c3                   	ret    

0000004d <main>:
int main(int argc, char *argv[])
{
  4d:	55                   	push   %ebp
  4e:	89 e5                	mov    %esp,%ebp
  50:	83 e4 f0             	and    $0xfffffff0,%esp
  53:	83 ec 30             	sub    $0x30,%esp

	int time_init;
        int time_end;
        int time_total;
        int time_avg;
        int x = 5;
  56:	c7 44 24 2c 05 00 00 	movl   $0x5,0x2c(%esp)
  5d:	00 
        int y = 0;
  5e:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  65:	00 
	
        time_init = uptime();
  66:	e8 c1 03 00 00       	call   42c <uptime>
  6b:	89 44 24 24          	mov    %eax,0x24(%esp)
        signal(SIGFPE, handle_signal);
  6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  76:	00 
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 e1 02 00 00       	call   364 <signal>
        x = x / y;
  83:	8b 44 24 2c          	mov    0x2c(%esp),%eax
  87:	99                   	cltd   
  88:	f7 7c 24 28          	idivl  0x28(%esp)
  8c:	89 44 24 2c          	mov    %eax,0x2c(%esp)
        time_end = uptime();
  90:	e8 97 03 00 00       	call   42c <uptime>
  95:	89 44 24 20          	mov    %eax,0x20(%esp)
        time_total = time_end - time_init;
  99:	8b 44 24 24          	mov    0x24(%esp),%eax
  9d:	8b 54 24 20          	mov    0x20(%esp),%edx
  a1:	89 d1                	mov    %edx,%ecx
  a3:	29 c1                	sub    %eax,%ecx
  a5:	89 c8                	mov    %ecx,%eax
  a7:	89 44 24 1c          	mov    %eax,0x1c(%esp)
        //this is in mticks, where one tick is 10^-6 mticks.
	time_avg = time_total*10;
  ab:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  af:	89 d0                	mov    %edx,%eax
  b1:	c1 e0 02             	shl    $0x2,%eax
  b4:	01 d0                	add    %edx,%eax
  b6:	d1 e0                	shl    %eax
  b8:	89 44 24 18          	mov    %eax,0x18(%esp)

        printf(1, "Traps Performed: %d\n", 100000);
  bc:	c7 44 24 08 a0 86 01 	movl   $0x186a0,0x8(%esp)
  c3:	00 
  c4:	c7 44 24 04 eb 08 00 	movl   $0x8eb,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 4c 04 00 00       	call   524 <printf>
        printf(1, "Total Elapsed Time: %d\n", time_total);
  d8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  e0:	c7 44 24 04 00 09 00 	movl   $0x900,0x4(%esp)
  e7:	00 
  e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ef:	e8 30 04 00 00       	call   524 <printf>
        printf(1, "Average Time Per Trap: %d\n", time_avg);
  f4:	8b 44 24 18          	mov    0x18(%esp),%eax
  f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  fc:	c7 44 24 04 18 09 00 	movl   $0x918,0x4(%esp)
 103:	00 
 104:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 10b:	e8 14 04 00 00       	call   524 <printf>

        exit();
 110:	e8 7f 02 00 00       	call   394 <exit>
 115:	66 90                	xchg   %ax,%ax
 117:	90                   	nop

00000118 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	57                   	push   %edi
 11c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 120:	8b 55 10             	mov    0x10(%ebp),%edx
 123:	8b 45 0c             	mov    0xc(%ebp),%eax
 126:	89 cb                	mov    %ecx,%ebx
 128:	89 df                	mov    %ebx,%edi
 12a:	89 d1                	mov    %edx,%ecx
 12c:	fc                   	cld    
 12d:	f3 aa                	rep stos %al,%es:(%edi)
 12f:	89 ca                	mov    %ecx,%edx
 131:	89 fb                	mov    %edi,%ebx
 133:	89 5d 08             	mov    %ebx,0x8(%ebp)
 136:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 139:	5b                   	pop    %ebx
 13a:	5f                   	pop    %edi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 149:	90                   	nop
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	8a 10                	mov    (%eax),%dl
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	88 10                	mov    %dl,(%eax)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	8a 00                	mov    (%eax),%al
 159:	84 c0                	test   %al,%al
 15b:	0f 95 c0             	setne  %al
 15e:	ff 45 08             	incl   0x8(%ebp)
 161:	ff 45 0c             	incl   0xc(%ebp)
 164:	84 c0                	test   %al,%al
 166:	75 e2                	jne    14a <strcpy+0xd>
    ;
  return os;
 168:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16b:	c9                   	leave  
 16c:	c3                   	ret    

0000016d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16d:	55                   	push   %ebp
 16e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 170:	eb 06                	jmp    178 <strcmp+0xb>
    p++, q++;
 172:	ff 45 08             	incl   0x8(%ebp)
 175:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	8a 00                	mov    (%eax),%al
 17d:	84 c0                	test   %al,%al
 17f:	74 0e                	je     18f <strcmp+0x22>
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	8a 10                	mov    (%eax),%dl
 186:	8b 45 0c             	mov    0xc(%ebp),%eax
 189:	8a 00                	mov    (%eax),%al
 18b:	38 c2                	cmp    %al,%dl
 18d:	74 e3                	je     172 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	8a 00                	mov    (%eax),%al
 194:	0f b6 d0             	movzbl %al,%edx
 197:	8b 45 0c             	mov    0xc(%ebp),%eax
 19a:	8a 00                	mov    (%eax),%al
 19c:	0f b6 c0             	movzbl %al,%eax
 19f:	89 d1                	mov    %edx,%ecx
 1a1:	29 c1                	sub    %eax,%ecx
 1a3:	89 c8                	mov    %ecx,%eax
}
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    

000001a7 <strlen>:

uint
strlen(char *s)
{
 1a7:	55                   	push   %ebp
 1a8:	89 e5                	mov    %esp,%ebp
 1aa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b4:	eb 03                	jmp    1b9 <strlen+0x12>
 1b6:	ff 45 fc             	incl   -0x4(%ebp)
 1b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	01 d0                	add    %edx,%eax
 1c1:	8a 00                	mov    (%eax),%al
 1c3:	84 c0                	test   %al,%al
 1c5:	75 ef                	jne    1b6 <strlen+0xf>
    ;
  return n;
 1c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ca:	c9                   	leave  
 1cb:	c3                   	ret    

000001cc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d2:	8b 45 10             	mov    0x10(%ebp),%eax
 1d5:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	89 04 24             	mov    %eax,(%esp)
 1e6:	e8 2d ff ff ff       	call   118 <stosb>
  return dst;
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ee:	c9                   	leave  
 1ef:	c3                   	ret    

000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	83 ec 04             	sub    $0x4,%esp
 1f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fc:	eb 12                	jmp    210 <strchr+0x20>
    if(*s == c)
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	8a 00                	mov    (%eax),%al
 203:	3a 45 fc             	cmp    -0x4(%ebp),%al
 206:	75 05                	jne    20d <strchr+0x1d>
      return (char*)s;
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	eb 11                	jmp    21e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 20d:	ff 45 08             	incl   0x8(%ebp)
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	8a 00                	mov    (%eax),%al
 215:	84 c0                	test   %al,%al
 217:	75 e5                	jne    1fe <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 219:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <gets>:

char*
gets(char *buf, int max)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 226:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 22d:	eb 42                	jmp    271 <gets+0x51>
    cc = read(0, &c, 1);
 22f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 236:	00 
 237:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23a:	89 44 24 04          	mov    %eax,0x4(%esp)
 23e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 245:	e8 62 01 00 00       	call   3ac <read>
 24a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 251:	7e 29                	jle    27c <gets+0x5c>
      break;
    buf[i++] = c;
 253:	8b 55 f4             	mov    -0xc(%ebp),%edx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	01 c2                	add    %eax,%edx
 25b:	8a 45 ef             	mov    -0x11(%ebp),%al
 25e:	88 02                	mov    %al,(%edx)
 260:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 263:	8a 45 ef             	mov    -0x11(%ebp),%al
 266:	3c 0a                	cmp    $0xa,%al
 268:	74 13                	je     27d <gets+0x5d>
 26a:	8a 45 ef             	mov    -0x11(%ebp),%al
 26d:	3c 0d                	cmp    $0xd,%al
 26f:	74 0c                	je     27d <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 271:	8b 45 f4             	mov    -0xc(%ebp),%eax
 274:	40                   	inc    %eax
 275:	3b 45 0c             	cmp    0xc(%ebp),%eax
 278:	7c b5                	jl     22f <gets+0xf>
 27a:	eb 01                	jmp    27d <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 27c:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 27d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	01 d0                	add    %edx,%eax
 285:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 288:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28b:	c9                   	leave  
 28c:	c3                   	ret    

0000028d <stat>:

int
stat(char *n, struct stat *st)
{
 28d:	55                   	push   %ebp
 28e:	89 e5                	mov    %esp,%ebp
 290:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 293:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 29a:	00 
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	89 04 24             	mov    %eax,(%esp)
 2a1:	e8 2e 01 00 00       	call   3d4 <open>
 2a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2ad:	79 07                	jns    2b6 <stat+0x29>
    return -1;
 2af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b4:	eb 23                	jmp    2d9 <stat+0x4c>
  r = fstat(fd, st);
 2b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c0:	89 04 24             	mov    %eax,(%esp)
 2c3:	e8 24 01 00 00       	call   3ec <fstat>
 2c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ce:	89 04 24             	mov    %eax,(%esp)
 2d1:	e8 e6 00 00 00       	call   3bc <close>
  return r;
 2d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d9:	c9                   	leave  
 2da:	c3                   	ret    

000002db <atoi>:

int
atoi(const char *s)
{
 2db:	55                   	push   %ebp
 2dc:	89 e5                	mov    %esp,%ebp
 2de:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e8:	eb 21                	jmp    30b <atoi+0x30>
    n = n*10 + *s++ - '0';
 2ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ed:	89 d0                	mov    %edx,%eax
 2ef:	c1 e0 02             	shl    $0x2,%eax
 2f2:	01 d0                	add    %edx,%eax
 2f4:	d1 e0                	shl    %eax
 2f6:	89 c2                	mov    %eax,%edx
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	8a 00                	mov    (%eax),%al
 2fd:	0f be c0             	movsbl %al,%eax
 300:	01 d0                	add    %edx,%eax
 302:	83 e8 30             	sub    $0x30,%eax
 305:	89 45 fc             	mov    %eax,-0x4(%ebp)
 308:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	8a 00                	mov    (%eax),%al
 310:	3c 2f                	cmp    $0x2f,%al
 312:	7e 09                	jle    31d <atoi+0x42>
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	8a 00                	mov    (%eax),%al
 319:	3c 39                	cmp    $0x39,%al
 31b:	7e cd                	jle    2ea <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 31d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32e:	8b 45 0c             	mov    0xc(%ebp),%eax
 331:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 334:	eb 10                	jmp    346 <memmove+0x24>
    *dst++ = *src++;
 336:	8b 45 f8             	mov    -0x8(%ebp),%eax
 339:	8a 10                	mov    (%eax),%dl
 33b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33e:	88 10                	mov    %dl,(%eax)
 340:	ff 45 fc             	incl   -0x4(%ebp)
 343:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 346:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 34a:	0f 9f c0             	setg   %al
 34d:	ff 4d 10             	decl   0x10(%ebp)
 350:	84 c0                	test   %al,%al
 352:	75 e2                	jne    336 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 354:	8b 45 08             	mov    0x8(%ebp),%eax
}
 357:	c9                   	leave  
 358:	c3                   	ret    

00000359 <trampoline>:
 359:	5a                   	pop    %edx
 35a:	59                   	pop    %ecx
 35b:	58                   	pop    %eax
 35c:	03 25 04 00 00 00    	add    0x4,%esp
 362:	c9                   	leave  
 363:	c3                   	ret    

00000364 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 36a:	c7 44 24 08 59 03 00 	movl   $0x359,0x8(%esp)
 371:	00 
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	89 44 24 04          	mov    %eax,0x4(%esp)
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	89 04 24             	mov    %eax,(%esp)
 37f:	e8 b8 00 00 00       	call   43c <register_signal_handler>
	return 0;
 384:	b8 00 00 00 00       	mov    $0x0,%eax
}
 389:	c9                   	leave  
 38a:	c3                   	ret    
 38b:	90                   	nop

0000038c <fork>:
 38c:	b8 01 00 00 00       	mov    $0x1,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <exit>:
 394:	b8 02 00 00 00       	mov    $0x2,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <wait>:
 39c:	b8 03 00 00 00       	mov    $0x3,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <pipe>:
 3a4:	b8 04 00 00 00       	mov    $0x4,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <read>:
 3ac:	b8 05 00 00 00       	mov    $0x5,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <write>:
 3b4:	b8 10 00 00 00       	mov    $0x10,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <close>:
 3bc:	b8 15 00 00 00       	mov    $0x15,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <kill>:
 3c4:	b8 06 00 00 00       	mov    $0x6,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <exec>:
 3cc:	b8 07 00 00 00       	mov    $0x7,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <open>:
 3d4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <mknod>:
 3dc:	b8 11 00 00 00       	mov    $0x11,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <unlink>:
 3e4:	b8 12 00 00 00       	mov    $0x12,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <fstat>:
 3ec:	b8 08 00 00 00       	mov    $0x8,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <link>:
 3f4:	b8 13 00 00 00       	mov    $0x13,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <mkdir>:
 3fc:	b8 14 00 00 00       	mov    $0x14,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <chdir>:
 404:	b8 09 00 00 00       	mov    $0x9,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <dup>:
 40c:	b8 0a 00 00 00       	mov    $0xa,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <getpid>:
 414:	b8 0b 00 00 00       	mov    $0xb,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <sbrk>:
 41c:	b8 0c 00 00 00       	mov    $0xc,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <sleep>:
 424:	b8 0d 00 00 00       	mov    $0xd,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <uptime>:
 42c:	b8 0e 00 00 00       	mov    $0xe,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <halt>:
 434:	b8 16 00 00 00       	mov    $0x16,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <register_signal_handler>:
 43c:	b8 17 00 00 00       	mov    $0x17,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <alarm>:
 444:	b8 18 00 00 00       	mov    $0x18,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	83 ec 28             	sub    $0x28,%esp
 452:	8b 45 0c             	mov    0xc(%ebp),%eax
 455:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 458:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 45f:	00 
 460:	8d 45 f4             	lea    -0xc(%ebp),%eax
 463:	89 44 24 04          	mov    %eax,0x4(%esp)
 467:	8b 45 08             	mov    0x8(%ebp),%eax
 46a:	89 04 24             	mov    %eax,(%esp)
 46d:	e8 42 ff ff ff       	call   3b4 <write>
}
 472:	c9                   	leave  
 473:	c3                   	ret    

00000474 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 47a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 481:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 485:	74 17                	je     49e <printint+0x2a>
 487:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 48b:	79 11                	jns    49e <printint+0x2a>
    neg = 1;
 48d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 494:	8b 45 0c             	mov    0xc(%ebp),%eax
 497:	f7 d8                	neg    %eax
 499:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49c:	eb 06                	jmp    4a4 <printint+0x30>
  } else {
    x = xx;
 49e:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b1:	ba 00 00 00 00       	mov    $0x0,%edx
 4b6:	f7 f1                	div    %ecx
 4b8:	89 d0                	mov    %edx,%eax
 4ba:	8a 80 b8 0b 00 00    	mov    0xbb8(%eax),%al
 4c0:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 4c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4c6:	01 ca                	add    %ecx,%edx
 4c8:	88 02                	mov    %al,(%edx)
 4ca:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4cd:	8b 55 10             	mov    0x10(%ebp),%edx
 4d0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d6:	ba 00 00 00 00       	mov    $0x0,%edx
 4db:	f7 75 d4             	divl   -0x2c(%ebp)
 4de:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e5:	75 c4                	jne    4ab <printint+0x37>
  if(neg)
 4e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4eb:	74 2c                	je     519 <printint+0xa5>
    buf[i++] = '-';
 4ed:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f3:	01 d0                	add    %edx,%eax
 4f5:	c6 00 2d             	movb   $0x2d,(%eax)
 4f8:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4fb:	eb 1c                	jmp    519 <printint+0xa5>
    putc(fd, buf[i]);
 4fd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 500:	8b 45 f4             	mov    -0xc(%ebp),%eax
 503:	01 d0                	add    %edx,%eax
 505:	8a 00                	mov    (%eax),%al
 507:	0f be c0             	movsbl %al,%eax
 50a:	89 44 24 04          	mov    %eax,0x4(%esp)
 50e:	8b 45 08             	mov    0x8(%ebp),%eax
 511:	89 04 24             	mov    %eax,(%esp)
 514:	e8 33 ff ff ff       	call   44c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 519:	ff 4d f4             	decl   -0xc(%ebp)
 51c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 520:	79 db                	jns    4fd <printint+0x89>
    putc(fd, buf[i]);
}
 522:	c9                   	leave  
 523:	c3                   	ret    

00000524 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 524:	55                   	push   %ebp
 525:	89 e5                	mov    %esp,%ebp
 527:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 52a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 531:	8d 45 0c             	lea    0xc(%ebp),%eax
 534:	83 c0 04             	add    $0x4,%eax
 537:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 53a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 541:	e9 78 01 00 00       	jmp    6be <printf+0x19a>
    c = fmt[i] & 0xff;
 546:	8b 55 0c             	mov    0xc(%ebp),%edx
 549:	8b 45 f0             	mov    -0x10(%ebp),%eax
 54c:	01 d0                	add    %edx,%eax
 54e:	8a 00                	mov    (%eax),%al
 550:	0f be c0             	movsbl %al,%eax
 553:	25 ff 00 00 00       	and    $0xff,%eax
 558:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 55b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55f:	75 2c                	jne    58d <printf+0x69>
      if(c == '%'){
 561:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 565:	75 0c                	jne    573 <printf+0x4f>
        state = '%';
 567:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56e:	e9 48 01 00 00       	jmp    6bb <printf+0x197>
      } else {
        putc(fd, c);
 573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 576:	0f be c0             	movsbl %al,%eax
 579:	89 44 24 04          	mov    %eax,0x4(%esp)
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	89 04 24             	mov    %eax,(%esp)
 583:	e8 c4 fe ff ff       	call   44c <putc>
 588:	e9 2e 01 00 00       	jmp    6bb <printf+0x197>
      }
    } else if(state == '%'){
 58d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 591:	0f 85 24 01 00 00    	jne    6bb <printf+0x197>
      if(c == 'd'){
 597:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 59b:	75 2d                	jne    5ca <printf+0xa6>
        printint(fd, *ap, 10, 1);
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5a9:	00 
 5aa:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5b1:	00 
 5b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
 5b9:	89 04 24             	mov    %eax,(%esp)
 5bc:	e8 b3 fe ff ff       	call   474 <printint>
        ap++;
 5c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c5:	e9 ea 00 00 00       	jmp    6b4 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 5ca:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ce:	74 06                	je     5d6 <printf+0xb2>
 5d0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5d4:	75 2d                	jne    603 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 5d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d9:	8b 00                	mov    (%eax),%eax
 5db:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5e2:	00 
 5e3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5ea:	00 
 5eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	89 04 24             	mov    %eax,(%esp)
 5f5:	e8 7a fe ff ff       	call   474 <printint>
        ap++;
 5fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fe:	e9 b1 00 00 00       	jmp    6b4 <printf+0x190>
      } else if(c == 's'){
 603:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 607:	75 43                	jne    64c <printf+0x128>
        s = (char*)*ap;
 609:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60c:	8b 00                	mov    (%eax),%eax
 60e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 611:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 619:	75 25                	jne    640 <printf+0x11c>
          s = "(null)";
 61b:	c7 45 f4 33 09 00 00 	movl   $0x933,-0xc(%ebp)
        while(*s != 0){
 622:	eb 1c                	jmp    640 <printf+0x11c>
          putc(fd, *s);
 624:	8b 45 f4             	mov    -0xc(%ebp),%eax
 627:	8a 00                	mov    (%eax),%al
 629:	0f be c0             	movsbl %al,%eax
 62c:	89 44 24 04          	mov    %eax,0x4(%esp)
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	89 04 24             	mov    %eax,(%esp)
 636:	e8 11 fe ff ff       	call   44c <putc>
          s++;
 63b:	ff 45 f4             	incl   -0xc(%ebp)
 63e:	eb 01                	jmp    641 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 640:	90                   	nop
 641:	8b 45 f4             	mov    -0xc(%ebp),%eax
 644:	8a 00                	mov    (%eax),%al
 646:	84 c0                	test   %al,%al
 648:	75 da                	jne    624 <printf+0x100>
 64a:	eb 68                	jmp    6b4 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 64c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 650:	75 1d                	jne    66f <printf+0x14b>
        putc(fd, *ap);
 652:	8b 45 e8             	mov    -0x18(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	0f be c0             	movsbl %al,%eax
 65a:	89 44 24 04          	mov    %eax,0x4(%esp)
 65e:	8b 45 08             	mov    0x8(%ebp),%eax
 661:	89 04 24             	mov    %eax,(%esp)
 664:	e8 e3 fd ff ff       	call   44c <putc>
        ap++;
 669:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66d:	eb 45                	jmp    6b4 <printf+0x190>
      } else if(c == '%'){
 66f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 673:	75 17                	jne    68c <printf+0x168>
        putc(fd, c);
 675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 678:	0f be c0             	movsbl %al,%eax
 67b:	89 44 24 04          	mov    %eax,0x4(%esp)
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
 682:	89 04 24             	mov    %eax,(%esp)
 685:	e8 c2 fd ff ff       	call   44c <putc>
 68a:	eb 28                	jmp    6b4 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 68c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 693:	00 
 694:	8b 45 08             	mov    0x8(%ebp),%eax
 697:	89 04 24             	mov    %eax,(%esp)
 69a:	e8 ad fd ff ff       	call   44c <putc>
        putc(fd, c);
 69f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a2:	0f be c0             	movsbl %al,%eax
 6a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ac:	89 04 24             	mov    %eax,(%esp)
 6af:	e8 98 fd ff ff       	call   44c <putc>
      }
      state = 0;
 6b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6bb:	ff 45 f0             	incl   -0x10(%ebp)
 6be:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c4:	01 d0                	add    %edx,%eax
 6c6:	8a 00                	mov    (%eax),%al
 6c8:	84 c0                	test   %al,%al
 6ca:	0f 85 76 fe ff ff    	jne    546 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d0:	c9                   	leave  
 6d1:	c3                   	ret    
 6d2:	66 90                	xchg   %ax,%ax

000006d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d4:	55                   	push   %ebp
 6d5:	89 e5                	mov    %esp,%ebp
 6d7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6da:	8b 45 08             	mov    0x8(%ebp),%eax
 6dd:	83 e8 08             	sub    $0x8,%eax
 6e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e3:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 6e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6eb:	eb 24                	jmp    711 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f5:	77 12                	ja     709 <free+0x35>
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fd:	77 24                	ja     723 <free+0x4f>
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 00                	mov    (%eax),%eax
 704:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 707:	77 1a                	ja     723 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 00                	mov    (%eax),%eax
 70e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 711:	8b 45 f8             	mov    -0x8(%ebp),%eax
 714:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 717:	76 d4                	jbe    6ed <free+0x19>
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 721:	76 ca                	jbe    6ed <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 723:	8b 45 f8             	mov    -0x8(%ebp),%eax
 726:	8b 40 04             	mov    0x4(%eax),%eax
 729:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 730:	8b 45 f8             	mov    -0x8(%ebp),%eax
 733:	01 c2                	add    %eax,%edx
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	8b 00                	mov    (%eax),%eax
 73a:	39 c2                	cmp    %eax,%edx
 73c:	75 24                	jne    762 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	8b 50 04             	mov    0x4(%eax),%edx
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	8b 40 04             	mov    0x4(%eax),%eax
 74c:	01 c2                	add    %eax,%edx
 74e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 751:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	8b 10                	mov    (%eax),%edx
 75b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75e:	89 10                	mov    %edx,(%eax)
 760:	eb 0a                	jmp    76c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 10                	mov    (%eax),%edx
 767:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 76c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	01 d0                	add    %edx,%eax
 77e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 781:	75 20                	jne    7a3 <free+0xcf>
    p->s.size += bp->s.size;
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 50 04             	mov    0x4(%eax),%edx
 789:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78c:	8b 40 04             	mov    0x4(%eax),%eax
 78f:	01 c2                	add    %eax,%edx
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 797:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79a:	8b 10                	mov    (%eax),%edx
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	89 10                	mov    %edx,(%eax)
 7a1:	eb 08                	jmp    7ab <free+0xd7>
  } else
    p->s.ptr = bp;
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a9:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	a3 d8 0b 00 00       	mov    %eax,0xbd8
}
 7b3:	c9                   	leave  
 7b4:	c3                   	ret    

000007b5 <morecore>:

static Header*
morecore(uint nu)
{
 7b5:	55                   	push   %ebp
 7b6:	89 e5                	mov    %esp,%ebp
 7b8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7bb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c2:	77 07                	ja     7cb <morecore+0x16>
    nu = 4096;
 7c4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7cb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ce:	c1 e0 03             	shl    $0x3,%eax
 7d1:	89 04 24             	mov    %eax,(%esp)
 7d4:	e8 43 fc ff ff       	call   41c <sbrk>
 7d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7dc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7e0:	75 07                	jne    7e9 <morecore+0x34>
    return 0;
 7e2:	b8 00 00 00 00       	mov    $0x0,%eax
 7e7:	eb 22                	jmp    80b <morecore+0x56>
  hp = (Header*)p;
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f2:	8b 55 08             	mov    0x8(%ebp),%edx
 7f5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fb:	83 c0 08             	add    $0x8,%eax
 7fe:	89 04 24             	mov    %eax,(%esp)
 801:	e8 ce fe ff ff       	call   6d4 <free>
  return freep;
 806:	a1 d8 0b 00 00       	mov    0xbd8,%eax
}
 80b:	c9                   	leave  
 80c:	c3                   	ret    

0000080d <malloc>:

void*
malloc(uint nbytes)
{
 80d:	55                   	push   %ebp
 80e:	89 e5                	mov    %esp,%ebp
 810:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 813:	8b 45 08             	mov    0x8(%ebp),%eax
 816:	83 c0 07             	add    $0x7,%eax
 819:	c1 e8 03             	shr    $0x3,%eax
 81c:	40                   	inc    %eax
 81d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 820:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 825:	89 45 f0             	mov    %eax,-0x10(%ebp)
 828:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82c:	75 23                	jne    851 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 82e:	c7 45 f0 d0 0b 00 00 	movl   $0xbd0,-0x10(%ebp)
 835:	8b 45 f0             	mov    -0x10(%ebp),%eax
 838:	a3 d8 0b 00 00       	mov    %eax,0xbd8
 83d:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 842:	a3 d0 0b 00 00       	mov    %eax,0xbd0
    base.s.size = 0;
 847:	c7 05 d4 0b 00 00 00 	movl   $0x0,0xbd4
 84e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 851:	8b 45 f0             	mov    -0x10(%ebp),%eax
 854:	8b 00                	mov    (%eax),%eax
 856:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 859:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85c:	8b 40 04             	mov    0x4(%eax),%eax
 85f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 862:	72 4d                	jb     8b1 <malloc+0xa4>
      if(p->s.size == nunits)
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	8b 40 04             	mov    0x4(%eax),%eax
 86a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86d:	75 0c                	jne    87b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	8b 10                	mov    (%eax),%edx
 874:	8b 45 f0             	mov    -0x10(%ebp),%eax
 877:	89 10                	mov    %edx,(%eax)
 879:	eb 26                	jmp    8a1 <malloc+0x94>
      else {
        p->s.size -= nunits;
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	8b 40 04             	mov    0x4(%eax),%eax
 881:	89 c2                	mov    %eax,%edx
 883:	2b 55 ec             	sub    -0x14(%ebp),%edx
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	8b 40 04             	mov    0x4(%eax),%eax
 892:	c1 e0 03             	shl    $0x3,%eax
 895:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 89e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a4:	a3 d8 0b 00 00       	mov    %eax,0xbd8
      return (void*)(p + 1);
 8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ac:	83 c0 08             	add    $0x8,%eax
 8af:	eb 38                	jmp    8e9 <malloc+0xdc>
    }
    if(p == freep)
 8b1:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 8b6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b9:	75 1b                	jne    8d6 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 8bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8be:	89 04 24             	mov    %eax,(%esp)
 8c1:	e8 ef fe ff ff       	call   7b5 <morecore>
 8c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8cd:	75 07                	jne    8d6 <malloc+0xc9>
        return 0;
 8cf:	b8 00 00 00 00       	mov    $0x0,%eax
 8d4:	eb 13                	jmp    8e9 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	8b 00                	mov    (%eax),%eax
 8e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e4:	e9 70 ff ff ff       	jmp    859 <malloc+0x4c>
}
 8e9:	c9                   	leave  
 8ea:	c3                   	ret    
