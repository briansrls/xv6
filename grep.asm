
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 c9 00 00 00       	jmp    db <grep+0xdb>
    m += n;
  12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  15:	01 45 ec             	add    %eax,-0x14(%ebp)
    buf[m] = '\0';
  18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1b:	c6 80 c0 0b 00 00 00 	movb   $0x0,0xbc0(%eax)
    p = buf;
  22:	c7 45 f0 c0 0b 00 00 	movl   $0xbc0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  29:	eb 53                	jmp    7e <grep+0x7e>
      *q = 0;
  2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2e:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  34:	89 44 24 04          	mov    %eax,0x4(%esp)
  38:	8b 45 08             	mov    0x8(%ebp),%eax
  3b:	89 04 24             	mov    %eax,(%esp)
  3e:	e8 b1 01 00 00       	call   1f4 <match>
  43:	85 c0                	test   %eax,%eax
  45:	74 2e                	je     75 <grep+0x75>
        *q = '\n';
  47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	89 c2                	mov    %eax,%edx
  55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  58:	89 d1                	mov    %edx,%ecx
  5a:	29 c1                	sub    %eax,%ecx
  5c:	89 c8                	mov    %ecx,%eax
  5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  65:	89 44 24 04          	mov    %eax,0x4(%esp)
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 97 05 00 00       	call   60c <write>
      }
      p = q+1;
  75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  78:	83 c0 01             	add    $0x1,%eax
  7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  7e:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  85:	00 
  86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  89:	89 04 24             	mov    %eax,(%esp)
  8c:	e8 ad 03 00 00       	call   43e <strchr>
  91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  98:	75 91                	jne    2b <grep+0x2b>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  9a:	81 7d f0 c0 0b 00 00 	cmpl   $0xbc0,-0x10(%ebp)
  a1:	75 07                	jne    aa <grep+0xaa>
      m = 0;
  a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    if(m > 0){
  aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  ae:	7e 2b                	jle    db <grep+0xdb>
      m -= p - buf;
  b0:	ba c0 0b 00 00       	mov    $0xbc0,%edx
  b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b8:	89 d1                	mov    %edx,%ecx
  ba:	29 c1                	sub    %eax,%ecx
  bc:	89 c8                	mov    %ecx,%eax
  be:	01 45 ec             	add    %eax,-0x14(%ebp)
      memmove(buf, p, m);
  c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  cf:	c7 04 24 c0 0b 00 00 	movl   $0xbc0,(%esp)
  d6:	e8 9f 04 00 00       	call   57a <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  de:	ba ff 03 00 00       	mov    $0x3ff,%edx
  e3:	89 d1                	mov    %edx,%ecx
  e5:	29 c1                	sub    %eax,%ecx
  e7:	89 c8                	mov    %ecx,%eax
  e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  ec:	81 c2 c0 0b 00 00    	add    $0xbc0,%edx
  f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	89 04 24             	mov    %eax,(%esp)
 100:	e8 ff 04 00 00       	call   604 <read>
 105:	89 45 e8             	mov    %eax,-0x18(%ebp)
 108:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 10c:	0f 8f 00 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 112:	c9                   	leave  
 113:	c3                   	ret    

00000114 <main>:

int
main(int argc, char *argv[])
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	83 e4 f0             	and    $0xfffffff0,%esp
 11a:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 11d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 121:	7f 19                	jg     13c <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 123:	c7 44 24 04 48 0b 00 	movl   $0xb48,0x4(%esp)
 12a:	00 
 12b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 132:	e8 49 06 00 00       	call   780 <printf>
    exit();
 137:	e8 b0 04 00 00       	call   5ec <exit>
  }
  pattern = argv[1];
 13c:	8b 45 0c             	mov    0xc(%ebp),%eax
 13f:	83 c0 04             	add    $0x4,%eax
 142:	8b 00                	mov    (%eax),%eax
 144:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  
  if(argc <= 2){
 148:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 14c:	7f 19                	jg     167 <main+0x53>
    grep(pattern, 0);
 14e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 155:	00 
 156:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 15a:	89 04 24             	mov    %eax,(%esp)
 15d:	e8 9e fe ff ff       	call   0 <grep>
    exit();
 162:	e8 85 04 00 00       	call   5ec <exit>
  }

  for(i = 2; i < argc; i++){
 167:	c7 44 24 18 02 00 00 	movl   $0x2,0x18(%esp)
 16e:	00 
 16f:	eb 75                	jmp    1e6 <main+0xd2>
    if((fd = open(argv[i], 0)) < 0){
 171:	8b 44 24 18          	mov    0x18(%esp),%eax
 175:	c1 e0 02             	shl    $0x2,%eax
 178:	03 45 0c             	add    0xc(%ebp),%eax
 17b:	8b 00                	mov    (%eax),%eax
 17d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 184:	00 
 185:	89 04 24             	mov    %eax,(%esp)
 188:	e8 9f 04 00 00       	call   62c <open>
 18d:	89 44 24 14          	mov    %eax,0x14(%esp)
 191:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 196:	79 29                	jns    1c1 <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 198:	8b 44 24 18          	mov    0x18(%esp),%eax
 19c:	c1 e0 02             	shl    $0x2,%eax
 19f:	03 45 0c             	add    0xc(%ebp),%eax
 1a2:	8b 00                	mov    (%eax),%eax
 1a4:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a8:	c7 44 24 04 68 0b 00 	movl   $0xb68,0x4(%esp)
 1af:	00 
 1b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b7:	e8 c4 05 00 00       	call   780 <printf>
      exit();
 1bc:	e8 2b 04 00 00       	call   5ec <exit>
    }
    grep(pattern, fd);
 1c1:	8b 44 24 14          	mov    0x14(%esp),%eax
 1c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1cd:	89 04 24             	mov    %eax,(%esp)
 1d0:	e8 2b fe ff ff       	call   0 <grep>
    close(fd);
 1d5:	8b 44 24 14          	mov    0x14(%esp),%eax
 1d9:	89 04 24             	mov    %eax,(%esp)
 1dc:	e8 33 04 00 00       	call   614 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1e1:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
 1e6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ea:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ed:	7c 82                	jl     171 <main+0x5d>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1ef:	e8 f8 03 00 00       	call   5ec <exit>

000001f4 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	0f b6 00             	movzbl (%eax),%eax
 200:	3c 5e                	cmp    $0x5e,%al
 202:	75 17                	jne    21b <match+0x27>
    return matchhere(re+1, text);
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	8d 50 01             	lea    0x1(%eax),%edx
 20a:	8b 45 0c             	mov    0xc(%ebp),%eax
 20d:	89 44 24 04          	mov    %eax,0x4(%esp)
 211:	89 14 24             	mov    %edx,(%esp)
 214:	e8 39 00 00 00       	call   252 <matchhere>
 219:	eb 35                	jmp    250 <match+0x5c>
  do{  // must look at empty string
    if(matchhere(re, text))
 21b:	8b 45 0c             	mov    0xc(%ebp),%eax
 21e:	89 44 24 04          	mov    %eax,0x4(%esp)
 222:	8b 45 08             	mov    0x8(%ebp),%eax
 225:	89 04 24             	mov    %eax,(%esp)
 228:	e8 25 00 00 00       	call   252 <matchhere>
 22d:	85 c0                	test   %eax,%eax
 22f:	74 07                	je     238 <match+0x44>
      return 1;
 231:	b8 01 00 00 00       	mov    $0x1,%eax
 236:	eb 18                	jmp    250 <match+0x5c>
  }while(*text++ != '\0');
 238:	8b 45 0c             	mov    0xc(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	84 c0                	test   %al,%al
 240:	0f 95 c0             	setne  %al
 243:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 247:	84 c0                	test   %al,%al
 249:	75 d0                	jne    21b <match+0x27>
  return 0;
 24b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 250:	c9                   	leave  
 251:	c3                   	ret    

00000252 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	0f b6 00             	movzbl (%eax),%eax
 25e:	84 c0                	test   %al,%al
 260:	75 0a                	jne    26c <matchhere+0x1a>
    return 1;
 262:	b8 01 00 00 00       	mov    $0x1,%eax
 267:	e9 9b 00 00 00       	jmp    307 <matchhere+0xb5>
  if(re[1] == '*')
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	83 c0 01             	add    $0x1,%eax
 272:	0f b6 00             	movzbl (%eax),%eax
 275:	3c 2a                	cmp    $0x2a,%al
 277:	75 24                	jne    29d <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	8d 48 02             	lea    0x2(%eax),%ecx
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	0f b6 00             	movzbl (%eax),%eax
 285:	0f be c0             	movsbl %al,%eax
 288:	8b 55 0c             	mov    0xc(%ebp),%edx
 28b:	89 54 24 08          	mov    %edx,0x8(%esp)
 28f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 293:	89 04 24             	mov    %eax,(%esp)
 296:	e8 6e 00 00 00       	call   309 <matchstar>
 29b:	eb 6a                	jmp    307 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	3c 24                	cmp    $0x24,%al
 2a5:	75 1d                	jne    2c4 <matchhere+0x72>
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	83 c0 01             	add    $0x1,%eax
 2ad:	0f b6 00             	movzbl (%eax),%eax
 2b0:	84 c0                	test   %al,%al
 2b2:	75 10                	jne    2c4 <matchhere+0x72>
    return *text == '\0';
 2b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b7:	0f b6 00             	movzbl (%eax),%eax
 2ba:	84 c0                	test   %al,%al
 2bc:	0f 94 c0             	sete   %al
 2bf:	0f b6 c0             	movzbl %al,%eax
 2c2:	eb 43                	jmp    307 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c7:	0f b6 00             	movzbl (%eax),%eax
 2ca:	84 c0                	test   %al,%al
 2cc:	74 34                	je     302 <matchhere+0xb0>
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	0f b6 00             	movzbl (%eax),%eax
 2d4:	3c 2e                	cmp    $0x2e,%al
 2d6:	74 10                	je     2e8 <matchhere+0x96>
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	0f b6 10             	movzbl (%eax),%edx
 2de:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e1:	0f b6 00             	movzbl (%eax),%eax
 2e4:	38 c2                	cmp    %al,%dl
 2e6:	75 1a                	jne    302 <matchhere+0xb0>
    return matchhere(re+1, text+1);
 2e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2eb:	8d 50 01             	lea    0x1(%eax),%edx
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	83 c0 01             	add    $0x1,%eax
 2f4:	89 54 24 04          	mov    %edx,0x4(%esp)
 2f8:	89 04 24             	mov    %eax,(%esp)
 2fb:	e8 52 ff ff ff       	call   252 <matchhere>
 300:	eb 05                	jmp    307 <matchhere+0xb5>
  return 0;
 302:	b8 00 00 00 00       	mov    $0x0,%eax
}
 307:	c9                   	leave  
 308:	c3                   	ret    

00000309 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 309:	55                   	push   %ebp
 30a:	89 e5                	mov    %esp,%ebp
 30c:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 30f:	8b 45 10             	mov    0x10(%ebp),%eax
 312:	89 44 24 04          	mov    %eax,0x4(%esp)
 316:	8b 45 0c             	mov    0xc(%ebp),%eax
 319:	89 04 24             	mov    %eax,(%esp)
 31c:	e8 31 ff ff ff       	call   252 <matchhere>
 321:	85 c0                	test   %eax,%eax
 323:	74 07                	je     32c <matchstar+0x23>
      return 1;
 325:	b8 01 00 00 00       	mov    $0x1,%eax
 32a:	eb 2c                	jmp    358 <matchstar+0x4f>
  }while(*text!='\0' && (*text++==c || c=='.'));
 32c:	8b 45 10             	mov    0x10(%ebp),%eax
 32f:	0f b6 00             	movzbl (%eax),%eax
 332:	84 c0                	test   %al,%al
 334:	74 1d                	je     353 <matchstar+0x4a>
 336:	8b 45 10             	mov    0x10(%ebp),%eax
 339:	0f b6 00             	movzbl (%eax),%eax
 33c:	0f be c0             	movsbl %al,%eax
 33f:	3b 45 08             	cmp    0x8(%ebp),%eax
 342:	0f 94 c0             	sete   %al
 345:	83 45 10 01          	addl   $0x1,0x10(%ebp)
 349:	84 c0                	test   %al,%al
 34b:	75 c2                	jne    30f <matchstar+0x6>
 34d:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 351:	74 bc                	je     30f <matchstar+0x6>
  return 0;
 353:	b8 00 00 00 00       	mov    $0x0,%eax
}
 358:	c9                   	leave  
 359:	c3                   	ret    
 35a:	90                   	nop
 35b:	90                   	nop

0000035c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	57                   	push   %edi
 360:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 361:	8b 4d 08             	mov    0x8(%ebp),%ecx
 364:	8b 55 10             	mov    0x10(%ebp),%edx
 367:	8b 45 0c             	mov    0xc(%ebp),%eax
 36a:	89 cb                	mov    %ecx,%ebx
 36c:	89 df                	mov    %ebx,%edi
 36e:	89 d1                	mov    %edx,%ecx
 370:	fc                   	cld    
 371:	f3 aa                	rep stos %al,%es:(%edi)
 373:	89 ca                	mov    %ecx,%edx
 375:	89 fb                	mov    %edi,%ebx
 377:	89 5d 08             	mov    %ebx,0x8(%ebp)
 37a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 37d:	5b                   	pop    %ebx
 37e:	5f                   	pop    %edi
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    

00000381 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 38d:	8b 45 0c             	mov    0xc(%ebp),%eax
 390:	0f b6 10             	movzbl (%eax),%edx
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	88 10                	mov    %dl,(%eax)
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	0f b6 00             	movzbl (%eax),%eax
 39e:	84 c0                	test   %al,%al
 3a0:	0f 95 c0             	setne  %al
 3a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3ab:	84 c0                	test   %al,%al
 3ad:	75 de                	jne    38d <strcpy+0xc>
    ;
  return os;
 3af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b2:	c9                   	leave  
 3b3:	c3                   	ret    

000003b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3b7:	eb 08                	jmp    3c1 <strcmp+0xd>
    p++, q++;
 3b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3bd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	0f b6 00             	movzbl (%eax),%eax
 3c7:	84 c0                	test   %al,%al
 3c9:	74 10                	je     3db <strcmp+0x27>
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	0f b6 10             	movzbl (%eax),%edx
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	0f b6 00             	movzbl (%eax),%eax
 3d7:	38 c2                	cmp    %al,%dl
 3d9:	74 de                	je     3b9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
 3de:	0f b6 00             	movzbl (%eax),%eax
 3e1:	0f b6 d0             	movzbl %al,%edx
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	0f b6 00             	movzbl (%eax),%eax
 3ea:	0f b6 c0             	movzbl %al,%eax
 3ed:	89 d1                	mov    %edx,%ecx
 3ef:	29 c1                	sub    %eax,%ecx
 3f1:	89 c8                	mov    %ecx,%eax
}
 3f3:	5d                   	pop    %ebp
 3f4:	c3                   	ret    

000003f5 <strlen>:

uint
strlen(char *s)
{
 3f5:	55                   	push   %ebp
 3f6:	89 e5                	mov    %esp,%ebp
 3f8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 402:	eb 04                	jmp    408 <strlen+0x13>
 404:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 408:	8b 45 fc             	mov    -0x4(%ebp),%eax
 40b:	03 45 08             	add    0x8(%ebp),%eax
 40e:	0f b6 00             	movzbl (%eax),%eax
 411:	84 c0                	test   %al,%al
 413:	75 ef                	jne    404 <strlen+0xf>
    ;
  return n;
 415:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 418:	c9                   	leave  
 419:	c3                   	ret    

0000041a <memset>:

void*
memset(void *dst, int c, uint n)
{
 41a:	55                   	push   %ebp
 41b:	89 e5                	mov    %esp,%ebp
 41d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 420:	8b 45 10             	mov    0x10(%ebp),%eax
 423:	89 44 24 08          	mov    %eax,0x8(%esp)
 427:	8b 45 0c             	mov    0xc(%ebp),%eax
 42a:	89 44 24 04          	mov    %eax,0x4(%esp)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	89 04 24             	mov    %eax,(%esp)
 434:	e8 23 ff ff ff       	call   35c <stosb>
  return dst;
 439:	8b 45 08             	mov    0x8(%ebp),%eax
}
 43c:	c9                   	leave  
 43d:	c3                   	ret    

0000043e <strchr>:

char*
strchr(const char *s, char c)
{
 43e:	55                   	push   %ebp
 43f:	89 e5                	mov    %esp,%ebp
 441:	83 ec 04             	sub    $0x4,%esp
 444:	8b 45 0c             	mov    0xc(%ebp),%eax
 447:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 44a:	eb 14                	jmp    460 <strchr+0x22>
    if(*s == c)
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
 44f:	0f b6 00             	movzbl (%eax),%eax
 452:	3a 45 fc             	cmp    -0x4(%ebp),%al
 455:	75 05                	jne    45c <strchr+0x1e>
      return (char*)s;
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	eb 13                	jmp    46f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 45c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 460:	8b 45 08             	mov    0x8(%ebp),%eax
 463:	0f b6 00             	movzbl (%eax),%eax
 466:	84 c0                	test   %al,%al
 468:	75 e2                	jne    44c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 46a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 46f:	c9                   	leave  
 470:	c3                   	ret    

00000471 <gets>:

char*
gets(char *buf, int max)
{
 471:	55                   	push   %ebp
 472:	89 e5                	mov    %esp,%ebp
 474:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 477:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47e:	eb 44                	jmp    4c4 <gets+0x53>
    cc = read(0, &c, 1);
 480:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 487:	00 
 488:	8d 45 ef             	lea    -0x11(%ebp),%eax
 48b:	89 44 24 04          	mov    %eax,0x4(%esp)
 48f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 496:	e8 69 01 00 00       	call   604 <read>
 49b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 49e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a2:	7e 2d                	jle    4d1 <gets+0x60>
      break;
    buf[i++] = c;
 4a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a7:	03 45 08             	add    0x8(%ebp),%eax
 4aa:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 4ae:	88 10                	mov    %dl,(%eax)
 4b0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 4b4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b8:	3c 0a                	cmp    $0xa,%al
 4ba:	74 16                	je     4d2 <gets+0x61>
 4bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c0:	3c 0d                	cmp    $0xd,%al
 4c2:	74 0e                	je     4d2 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4c7:	83 c0 01             	add    $0x1,%eax
 4ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4cd:	7c b1                	jl     480 <gets+0xf>
 4cf:	eb 01                	jmp    4d2 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4d1:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4d5:	03 45 08             	add    0x8(%ebp),%eax
 4d8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4de:	c9                   	leave  
 4df:	c3                   	ret    

000004e0 <stat>:

int
stat(char *n, struct stat *st)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4ed:	00 
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
 4f1:	89 04 24             	mov    %eax,(%esp)
 4f4:	e8 33 01 00 00       	call   62c <open>
 4f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 4fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 500:	79 07                	jns    509 <stat+0x29>
    return -1;
 502:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 507:	eb 23                	jmp    52c <stat+0x4c>
  r = fstat(fd, st);
 509:	8b 45 0c             	mov    0xc(%ebp),%eax
 50c:	89 44 24 04          	mov    %eax,0x4(%esp)
 510:	8b 45 f0             	mov    -0x10(%ebp),%eax
 513:	89 04 24             	mov    %eax,(%esp)
 516:	e8 29 01 00 00       	call   644 <fstat>
 51b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 51e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 521:	89 04 24             	mov    %eax,(%esp)
 524:	e8 eb 00 00 00       	call   614 <close>
  return r;
 529:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 52c:	c9                   	leave  
 52d:	c3                   	ret    

0000052e <atoi>:

int
atoi(const char *s)
{
 52e:	55                   	push   %ebp
 52f:	89 e5                	mov    %esp,%ebp
 531:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 534:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 53b:	eb 24                	jmp    561 <atoi+0x33>
    n = n*10 + *s++ - '0';
 53d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 540:	89 d0                	mov    %edx,%eax
 542:	c1 e0 02             	shl    $0x2,%eax
 545:	01 d0                	add    %edx,%eax
 547:	01 c0                	add    %eax,%eax
 549:	89 c2                	mov    %eax,%edx
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	0f b6 00             	movzbl (%eax),%eax
 551:	0f be c0             	movsbl %al,%eax
 554:	8d 04 02             	lea    (%edx,%eax,1),%eax
 557:	83 e8 30             	sub    $0x30,%eax
 55a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 55d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 561:	8b 45 08             	mov    0x8(%ebp),%eax
 564:	0f b6 00             	movzbl (%eax),%eax
 567:	3c 2f                	cmp    $0x2f,%al
 569:	7e 0a                	jle    575 <atoi+0x47>
 56b:	8b 45 08             	mov    0x8(%ebp),%eax
 56e:	0f b6 00             	movzbl (%eax),%eax
 571:	3c 39                	cmp    $0x39,%al
 573:	7e c8                	jle    53d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 575:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 578:	c9                   	leave  
 579:	c3                   	ret    

0000057a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 57a:	55                   	push   %ebp
 57b:	89 e5                	mov    %esp,%ebp
 57d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 580:	8b 45 08             	mov    0x8(%ebp),%eax
 583:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 586:	8b 45 0c             	mov    0xc(%ebp),%eax
 589:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 58c:	eb 13                	jmp    5a1 <memmove+0x27>
    *dst++ = *src++;
 58e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 591:	0f b6 10             	movzbl (%eax),%edx
 594:	8b 45 f8             	mov    -0x8(%ebp),%eax
 597:	88 10                	mov    %dl,(%eax)
 599:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 59d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5a5:	0f 9f c0             	setg   %al
 5a8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 5ac:	84 c0                	test   %al,%al
 5ae:	75 de                	jne    58e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b3:	c9                   	leave  
 5b4:	c3                   	ret    

000005b5 <trampoline>:
 5b5:	5a                   	pop    %edx
 5b6:	59                   	pop    %ecx
 5b7:	58                   	pop    %eax
 5b8:	c9                   	leave  
 5b9:	c3                   	ret    

000005ba <signal>:
//	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 5ba:	55                   	push   %ebp
 5bb:	89 e5                	mov    %esp,%ebp
 5bd:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 5c0:	c7 44 24 08 b5 05 00 	movl   $0x5b5,0x8(%esp)
 5c7:	00 
 5c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 5cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	89 04 24             	mov    %eax,(%esp)
 5d5:	e8 ba 00 00 00       	call   694 <register_signal_handler>
	return 0;
 5da:	b8 00 00 00 00       	mov    $0x0,%eax
}
 5df:	c9                   	leave  
 5e0:	c3                   	ret    
 5e1:	90                   	nop
 5e2:	90                   	nop
 5e3:	90                   	nop

000005e4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5e4:	b8 01 00 00 00       	mov    $0x1,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <exit>:
SYSCALL(exit)
 5ec:	b8 02 00 00 00       	mov    $0x2,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <wait>:
SYSCALL(wait)
 5f4:	b8 03 00 00 00       	mov    $0x3,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <pipe>:
SYSCALL(pipe)
 5fc:	b8 04 00 00 00       	mov    $0x4,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <read>:
SYSCALL(read)
 604:	b8 05 00 00 00       	mov    $0x5,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <write>:
SYSCALL(write)
 60c:	b8 10 00 00 00       	mov    $0x10,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <close>:
SYSCALL(close)
 614:	b8 15 00 00 00       	mov    $0x15,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <kill>:
SYSCALL(kill)
 61c:	b8 06 00 00 00       	mov    $0x6,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <exec>:
SYSCALL(exec)
 624:	b8 07 00 00 00       	mov    $0x7,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <open>:
SYSCALL(open)
 62c:	b8 0f 00 00 00       	mov    $0xf,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <mknod>:
SYSCALL(mknod)
 634:	b8 11 00 00 00       	mov    $0x11,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <unlink>:
SYSCALL(unlink)
 63c:	b8 12 00 00 00       	mov    $0x12,%eax
 641:	cd 40                	int    $0x40
 643:	c3                   	ret    

00000644 <fstat>:
SYSCALL(fstat)
 644:	b8 08 00 00 00       	mov    $0x8,%eax
 649:	cd 40                	int    $0x40
 64b:	c3                   	ret    

0000064c <link>:
SYSCALL(link)
 64c:	b8 13 00 00 00       	mov    $0x13,%eax
 651:	cd 40                	int    $0x40
 653:	c3                   	ret    

00000654 <mkdir>:
SYSCALL(mkdir)
 654:	b8 14 00 00 00       	mov    $0x14,%eax
 659:	cd 40                	int    $0x40
 65b:	c3                   	ret    

0000065c <chdir>:
SYSCALL(chdir)
 65c:	b8 09 00 00 00       	mov    $0x9,%eax
 661:	cd 40                	int    $0x40
 663:	c3                   	ret    

00000664 <dup>:
SYSCALL(dup)
 664:	b8 0a 00 00 00       	mov    $0xa,%eax
 669:	cd 40                	int    $0x40
 66b:	c3                   	ret    

0000066c <getpid>:
SYSCALL(getpid)
 66c:	b8 0b 00 00 00       	mov    $0xb,%eax
 671:	cd 40                	int    $0x40
 673:	c3                   	ret    

00000674 <sbrk>:
SYSCALL(sbrk)
 674:	b8 0c 00 00 00       	mov    $0xc,%eax
 679:	cd 40                	int    $0x40
 67b:	c3                   	ret    

0000067c <sleep>:
SYSCALL(sleep)
 67c:	b8 0d 00 00 00       	mov    $0xd,%eax
 681:	cd 40                	int    $0x40
 683:	c3                   	ret    

00000684 <uptime>:
SYSCALL(uptime)
 684:	b8 0e 00 00 00       	mov    $0xe,%eax
 689:	cd 40                	int    $0x40
 68b:	c3                   	ret    

0000068c <halt>:
SYSCALL(halt)
 68c:	b8 16 00 00 00       	mov    $0x16,%eax
 691:	cd 40                	int    $0x40
 693:	c3                   	ret    

00000694 <register_signal_handler>:
SYSCALL(register_signal_handler)
 694:	b8 17 00 00 00       	mov    $0x17,%eax
 699:	cd 40                	int    $0x40
 69b:	c3                   	ret    

0000069c <alarm>:
SYSCALL(alarm)
 69c:	b8 18 00 00 00       	mov    $0x18,%eax
 6a1:	cd 40                	int    $0x40
 6a3:	c3                   	ret    

000006a4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6a4:	55                   	push   %ebp
 6a5:	89 e5                	mov    %esp,%ebp
 6a7:	83 ec 28             	sub    $0x28,%esp
 6aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ad:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6b7:	00 
 6b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bf:	8b 45 08             	mov    0x8(%ebp),%eax
 6c2:	89 04 24             	mov    %eax,(%esp)
 6c5:	e8 42 ff ff ff       	call   60c <write>
}
 6ca:	c9                   	leave  
 6cb:	c3                   	ret    

000006cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6cc:	55                   	push   %ebp
 6cd:	89 e5                	mov    %esp,%ebp
 6cf:	53                   	push   %ebx
 6d0:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6da:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6de:	74 17                	je     6f7 <printint+0x2b>
 6e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6e4:	79 11                	jns    6f7 <printint+0x2b>
    neg = 1;
 6e6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f0:	f7 d8                	neg    %eax
 6f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6f5:	eb 06                	jmp    6fd <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 6fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 6fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 704:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 707:	8b 5d 10             	mov    0x10(%ebp),%ebx
 70a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70d:	ba 00 00 00 00       	mov    $0x0,%edx
 712:	f7 f3                	div    %ebx
 714:	89 d0                	mov    %edx,%eax
 716:	0f b6 80 88 0b 00 00 	movzbl 0xb88(%eax),%eax
 71d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 721:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 725:	8b 45 10             	mov    0x10(%ebp),%eax
 728:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 72b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72e:	ba 00 00 00 00       	mov    $0x0,%edx
 733:	f7 75 d4             	divl   -0x2c(%ebp)
 736:	89 45 f4             	mov    %eax,-0xc(%ebp)
 739:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 73d:	75 c5                	jne    704 <printint+0x38>
  if(neg)
 73f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 743:	74 2a                	je     76f <printint+0xa3>
    buf[i++] = '-';
 745:	8b 45 ec             	mov    -0x14(%ebp),%eax
 748:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 74d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 751:	eb 1d                	jmp    770 <printint+0xa4>
    putc(fd, buf[i]);
 753:	8b 45 ec             	mov    -0x14(%ebp),%eax
 756:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 75b:	0f be c0             	movsbl %al,%eax
 75e:	89 44 24 04          	mov    %eax,0x4(%esp)
 762:	8b 45 08             	mov    0x8(%ebp),%eax
 765:	89 04 24             	mov    %eax,(%esp)
 768:	e8 37 ff ff ff       	call   6a4 <putc>
 76d:	eb 01                	jmp    770 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 76f:	90                   	nop
 770:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 774:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 778:	79 d9                	jns    753 <printint+0x87>
    putc(fd, buf[i]);
}
 77a:	83 c4 44             	add    $0x44,%esp
 77d:	5b                   	pop    %ebx
 77e:	5d                   	pop    %ebp
 77f:	c3                   	ret    

00000780 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 786:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 78d:	8d 45 0c             	lea    0xc(%ebp),%eax
 790:	83 c0 04             	add    $0x4,%eax
 793:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 796:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 79d:	e9 7e 01 00 00       	jmp    920 <printf+0x1a0>
    c = fmt[i] & 0xff;
 7a2:	8b 55 0c             	mov    0xc(%ebp),%edx
 7a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a8:	8d 04 02             	lea    (%edx,%eax,1),%eax
 7ab:	0f b6 00             	movzbl (%eax),%eax
 7ae:	0f be c0             	movsbl %al,%eax
 7b1:	25 ff 00 00 00       	and    $0xff,%eax
 7b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 7b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7bd:	75 2c                	jne    7eb <printf+0x6b>
      if(c == '%'){
 7bf:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 7c3:	75 0c                	jne    7d1 <printf+0x51>
        state = '%';
 7c5:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 7cc:	e9 4b 01 00 00       	jmp    91c <printf+0x19c>
      } else {
        putc(fd, c);
 7d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d4:	0f be c0             	movsbl %al,%eax
 7d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7db:	8b 45 08             	mov    0x8(%ebp),%eax
 7de:	89 04 24             	mov    %eax,(%esp)
 7e1:	e8 be fe ff ff       	call   6a4 <putc>
 7e6:	e9 31 01 00 00       	jmp    91c <printf+0x19c>
      }
    } else if(state == '%'){
 7eb:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 7ef:	0f 85 27 01 00 00    	jne    91c <printf+0x19c>
      if(c == 'd'){
 7f5:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 7f9:	75 2d                	jne    828 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	8b 00                	mov    (%eax),%eax
 800:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 807:	00 
 808:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 80f:	00 
 810:	89 44 24 04          	mov    %eax,0x4(%esp)
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	89 04 24             	mov    %eax,(%esp)
 81a:	e8 ad fe ff ff       	call   6cc <printint>
        ap++;
 81f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 823:	e9 ed 00 00 00       	jmp    915 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 828:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 82c:	74 06                	je     834 <printf+0xb4>
 82e:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 832:	75 2d                	jne    861 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	8b 00                	mov    (%eax),%eax
 839:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 840:	00 
 841:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 848:	00 
 849:	89 44 24 04          	mov    %eax,0x4(%esp)
 84d:	8b 45 08             	mov    0x8(%ebp),%eax
 850:	89 04 24             	mov    %eax,(%esp)
 853:	e8 74 fe ff ff       	call   6cc <printint>
        ap++;
 858:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 85c:	e9 b4 00 00 00       	jmp    915 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 861:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 865:	75 46                	jne    8ad <printf+0x12d>
        s = (char*)*ap;
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	8b 00                	mov    (%eax),%eax
 86c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 86f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 873:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 877:	75 27                	jne    8a0 <printf+0x120>
          s = "(null)";
 879:	c7 45 e4 7e 0b 00 00 	movl   $0xb7e,-0x1c(%ebp)
        while(*s != 0){
 880:	eb 1f                	jmp    8a1 <printf+0x121>
          putc(fd, *s);
 882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 885:	0f b6 00             	movzbl (%eax),%eax
 888:	0f be c0             	movsbl %al,%eax
 88b:	89 44 24 04          	mov    %eax,0x4(%esp)
 88f:	8b 45 08             	mov    0x8(%ebp),%eax
 892:	89 04 24             	mov    %eax,(%esp)
 895:	e8 0a fe ff ff       	call   6a4 <putc>
          s++;
 89a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 89e:	eb 01                	jmp    8a1 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8a0:	90                   	nop
 8a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a4:	0f b6 00             	movzbl (%eax),%eax
 8a7:	84 c0                	test   %al,%al
 8a9:	75 d7                	jne    882 <printf+0x102>
 8ab:	eb 68                	jmp    915 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8ad:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 8b1:	75 1d                	jne    8d0 <printf+0x150>
        putc(fd, *ap);
 8b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b6:	8b 00                	mov    (%eax),%eax
 8b8:	0f be c0             	movsbl %al,%eax
 8bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 8bf:	8b 45 08             	mov    0x8(%ebp),%eax
 8c2:	89 04 24             	mov    %eax,(%esp)
 8c5:	e8 da fd ff ff       	call   6a4 <putc>
        ap++;
 8ca:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 8ce:	eb 45                	jmp    915 <printf+0x195>
      } else if(c == '%'){
 8d0:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 8d4:	75 17                	jne    8ed <printf+0x16d>
        putc(fd, c);
 8d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d9:	0f be c0             	movsbl %al,%eax
 8dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e0:	8b 45 08             	mov    0x8(%ebp),%eax
 8e3:	89 04 24             	mov    %eax,(%esp)
 8e6:	e8 b9 fd ff ff       	call   6a4 <putc>
 8eb:	eb 28                	jmp    915 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8ed:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8f4:	00 
 8f5:	8b 45 08             	mov    0x8(%ebp),%eax
 8f8:	89 04 24             	mov    %eax,(%esp)
 8fb:	e8 a4 fd ff ff       	call   6a4 <putc>
        putc(fd, c);
 900:	8b 45 e8             	mov    -0x18(%ebp),%eax
 903:	0f be c0             	movsbl %al,%eax
 906:	89 44 24 04          	mov    %eax,0x4(%esp)
 90a:	8b 45 08             	mov    0x8(%ebp),%eax
 90d:	89 04 24             	mov    %eax,(%esp)
 910:	e8 8f fd ff ff       	call   6a4 <putc>
      }
      state = 0;
 915:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 91c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 920:	8b 55 0c             	mov    0xc(%ebp),%edx
 923:	8b 45 ec             	mov    -0x14(%ebp),%eax
 926:	8d 04 02             	lea    (%edx,%eax,1),%eax
 929:	0f b6 00             	movzbl (%eax),%eax
 92c:	84 c0                	test   %al,%al
 92e:	0f 85 6e fe ff ff    	jne    7a2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 934:	c9                   	leave  
 935:	c3                   	ret    
 936:	90                   	nop
 937:	90                   	nop

00000938 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 938:	55                   	push   %ebp
 939:	89 e5                	mov    %esp,%ebp
 93b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 93e:	8b 45 08             	mov    0x8(%ebp),%eax
 941:	83 e8 08             	sub    $0x8,%eax
 944:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 947:	a1 a8 0b 00 00       	mov    0xba8,%eax
 94c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 94f:	eb 24                	jmp    975 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 951:	8b 45 fc             	mov    -0x4(%ebp),%eax
 954:	8b 00                	mov    (%eax),%eax
 956:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 959:	77 12                	ja     96d <free+0x35>
 95b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 961:	77 24                	ja     987 <free+0x4f>
 963:	8b 45 fc             	mov    -0x4(%ebp),%eax
 966:	8b 00                	mov    (%eax),%eax
 968:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 96b:	77 1a                	ja     987 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 970:	8b 00                	mov    (%eax),%eax
 972:	89 45 fc             	mov    %eax,-0x4(%ebp)
 975:	8b 45 f8             	mov    -0x8(%ebp),%eax
 978:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 97b:	76 d4                	jbe    951 <free+0x19>
 97d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 980:	8b 00                	mov    (%eax),%eax
 982:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 985:	76 ca                	jbe    951 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 987:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98a:	8b 40 04             	mov    0x4(%eax),%eax
 98d:	c1 e0 03             	shl    $0x3,%eax
 990:	89 c2                	mov    %eax,%edx
 992:	03 55 f8             	add    -0x8(%ebp),%edx
 995:	8b 45 fc             	mov    -0x4(%ebp),%eax
 998:	8b 00                	mov    (%eax),%eax
 99a:	39 c2                	cmp    %eax,%edx
 99c:	75 24                	jne    9c2 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 99e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a1:	8b 50 04             	mov    0x4(%eax),%edx
 9a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a7:	8b 00                	mov    (%eax),%eax
 9a9:	8b 40 04             	mov    0x4(%eax),%eax
 9ac:	01 c2                	add    %eax,%edx
 9ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b7:	8b 00                	mov    (%eax),%eax
 9b9:	8b 10                	mov    (%eax),%edx
 9bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9be:	89 10                	mov    %edx,(%eax)
 9c0:	eb 0a                	jmp    9cc <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 9c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c5:	8b 10                	mov    (%eax),%edx
 9c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cf:	8b 40 04             	mov    0x4(%eax),%eax
 9d2:	c1 e0 03             	shl    $0x3,%eax
 9d5:	03 45 fc             	add    -0x4(%ebp),%eax
 9d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9db:	75 20                	jne    9fd <free+0xc5>
    p->s.size += bp->s.size;
 9dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e0:	8b 50 04             	mov    0x4(%eax),%edx
 9e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e6:	8b 40 04             	mov    0x4(%eax),%eax
 9e9:	01 c2                	add    %eax,%edx
 9eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ee:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f4:	8b 10                	mov    (%eax),%edx
 9f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f9:	89 10                	mov    %edx,(%eax)
 9fb:	eb 08                	jmp    a05 <free+0xcd>
  } else
    p->s.ptr = bp;
 9fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a00:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a03:	89 10                	mov    %edx,(%eax)
  freep = p;
 a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a08:	a3 a8 0b 00 00       	mov    %eax,0xba8
}
 a0d:	c9                   	leave  
 a0e:	c3                   	ret    

00000a0f <morecore>:

static Header*
morecore(uint nu)
{
 a0f:	55                   	push   %ebp
 a10:	89 e5                	mov    %esp,%ebp
 a12:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a15:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a1c:	77 07                	ja     a25 <morecore+0x16>
    nu = 4096;
 a1e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a25:	8b 45 08             	mov    0x8(%ebp),%eax
 a28:	c1 e0 03             	shl    $0x3,%eax
 a2b:	89 04 24             	mov    %eax,(%esp)
 a2e:	e8 41 fc ff ff       	call   674 <sbrk>
 a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 a36:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 a3a:	75 07                	jne    a43 <morecore+0x34>
    return 0;
 a3c:	b8 00 00 00 00       	mov    $0x0,%eax
 a41:	eb 22                	jmp    a65 <morecore+0x56>
  hp = (Header*)p;
 a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4c:	8b 55 08             	mov    0x8(%ebp),%edx
 a4f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a55:	83 c0 08             	add    $0x8,%eax
 a58:	89 04 24             	mov    %eax,(%esp)
 a5b:	e8 d8 fe ff ff       	call   938 <free>
  return freep;
 a60:	a1 a8 0b 00 00       	mov    0xba8,%eax
}
 a65:	c9                   	leave  
 a66:	c3                   	ret    

00000a67 <malloc>:

void*
malloc(uint nbytes)
{
 a67:	55                   	push   %ebp
 a68:	89 e5                	mov    %esp,%ebp
 a6a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a6d:	8b 45 08             	mov    0x8(%ebp),%eax
 a70:	83 c0 07             	add    $0x7,%eax
 a73:	c1 e8 03             	shr    $0x3,%eax
 a76:	83 c0 01             	add    $0x1,%eax
 a79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 a7c:	a1 a8 0b 00 00       	mov    0xba8,%eax
 a81:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a88:	75 23                	jne    aad <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a8a:	c7 45 f0 a0 0b 00 00 	movl   $0xba0,-0x10(%ebp)
 a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a94:	a3 a8 0b 00 00       	mov    %eax,0xba8
 a99:	a1 a8 0b 00 00       	mov    0xba8,%eax
 a9e:	a3 a0 0b 00 00       	mov    %eax,0xba0
    base.s.size = 0;
 aa3:	c7 05 a4 0b 00 00 00 	movl   $0x0,0xba4
 aaa:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab0:	8b 00                	mov    (%eax),%eax
 ab2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ab8:	8b 40 04             	mov    0x4(%eax),%eax
 abb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 abe:	72 4d                	jb     b0d <malloc+0xa6>
      if(p->s.size == nunits)
 ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ac3:	8b 40 04             	mov    0x4(%eax),%eax
 ac6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 ac9:	75 0c                	jne    ad7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ace:	8b 10                	mov    (%eax),%edx
 ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad3:	89 10                	mov    %edx,(%eax)
 ad5:	eb 26                	jmp    afd <malloc+0x96>
      else {
        p->s.size -= nunits;
 ad7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ada:	8b 40 04             	mov    0x4(%eax),%eax
 add:	89 c2                	mov    %eax,%edx
 adf:	2b 55 f4             	sub    -0xc(%ebp),%edx
 ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ae5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aeb:	8b 40 04             	mov    0x4(%eax),%eax
 aee:	c1 e0 03             	shl    $0x3,%eax
 af1:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 af4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 afa:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b00:	a3 a8 0b 00 00       	mov    %eax,0xba8
      return (void*)(p + 1);
 b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b08:	83 c0 08             	add    $0x8,%eax
 b0b:	eb 38                	jmp    b45 <malloc+0xde>
    }
    if(p == freep)
 b0d:	a1 a8 0b 00 00       	mov    0xba8,%eax
 b12:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 b15:	75 1b                	jne    b32 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1a:	89 04 24             	mov    %eax,(%esp)
 b1d:	e8 ed fe ff ff       	call   a0f <morecore>
 b22:	89 45 ec             	mov    %eax,-0x14(%ebp)
 b25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b29:	75 07                	jne    b32 <malloc+0xcb>
        return 0;
 b2b:	b8 00 00 00 00       	mov    $0x0,%eax
 b30:	eb 13                	jmp    b45 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b32:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b3b:	8b 00                	mov    (%eax),%eax
 b3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b40:	e9 70 ff ff ff       	jmp    ab5 <malloc+0x4e>
}
 b45:	c9                   	leave  
 b46:	c3                   	ret    
