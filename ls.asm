
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 db 03 00 00       	call   3ed <strlen>
  12:	03 45 08             	add    0x8(%ebp),%eax
  15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  18:	eb 04                	jmp    1e <fmtname+0x1e>
  1a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  21:	3b 45 08             	cmp    0x8(%ebp),%eax
  24:	72 0a                	jb     30 <fmtname+0x30>
  26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  29:	0f b6 00             	movzbl (%eax),%eax
  2c:	3c 2f                	cmp    $0x2f,%al
  2e:	75 ea                	jne    1a <fmtname+0x1a>
    ;
  p++;
  30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  37:	89 04 24             	mov    %eax,(%esp)
  3a:	e8 ae 03 00 00       	call   3ed <strlen>
  3f:	83 f8 0d             	cmp    $0xd,%eax
  42:	76 05                	jbe    49 <fmtname+0x49>
    return p;
  44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  47:	eb 5f                	jmp    a8 <fmtname+0xa8>
  memmove(buf, p, strlen(p));
  49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 99 03 00 00       	call   3ed <strlen>
  54:	89 44 24 08          	mov    %eax,0x8(%esp)
  58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  5f:	c7 04 24 a4 0b 00 00 	movl   $0xba4,(%esp)
  66:	e8 07 05 00 00       	call   572 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6e:	89 04 24             	mov    %eax,(%esp)
  71:	e8 77 03 00 00       	call   3ed <strlen>
  76:	ba 0e 00 00 00       	mov    $0xe,%edx
  7b:	89 d3                	mov    %edx,%ebx
  7d:	29 c3                	sub    %eax,%ebx
  7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  82:	89 04 24             	mov    %eax,(%esp)
  85:	e8 63 03 00 00       	call   3ed <strlen>
  8a:	05 a4 0b 00 00       	add    $0xba4,%eax
  8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  93:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  9a:	00 
  9b:	89 04 24             	mov    %eax,(%esp)
  9e:	e8 6f 03 00 00       	call   412 <memset>
  return buf;
  a3:	b8 a4 0b 00 00       	mov    $0xba4,%eax
}
  a8:	83 c4 24             	add    $0x24,%esp
  ab:	5b                   	pop    %ebx
  ac:	5d                   	pop    %ebp
  ad:	c3                   	ret    

000000ae <ls>:

void
ls(char *path)
{
  ae:	55                   	push   %ebp
  af:	89 e5                	mov    %esp,%ebp
  b1:	57                   	push   %edi
  b2:	56                   	push   %esi
  b3:	53                   	push   %ebx
  b4:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c1:	00 
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	89 04 24             	mov    %eax,(%esp)
  c8:	e8 57 05 00 00       	call   624 <open>
  cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d4:	79 20                	jns    f6 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  dd:	c7 44 24 04 3f 0b 00 	movl   $0xb3f,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ec:	e8 87 06 00 00       	call   778 <printf>
    return;
  f1:	e9 01 02 00 00       	jmp    2f7 <ls+0x249>
  }
  
  if(fstat(fd, &st) < 0){
  f6:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 103:	89 04 24             	mov    %eax,(%esp)
 106:	e8 31 05 00 00       	call   63c <fstat>
 10b:	85 c0                	test   %eax,%eax
 10d:	79 2b                	jns    13a <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	89 44 24 08          	mov    %eax,0x8(%esp)
 116:	c7 44 24 04 53 0b 00 	movl   $0xb53,0x4(%esp)
 11d:	00 
 11e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 125:	e8 4e 06 00 00       	call   778 <printf>
    close(fd);
 12a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12d:	89 04 24             	mov    %eax,(%esp)
 130:	e8 d7 04 00 00       	call   60c <close>
    return;
 135:	e9 bd 01 00 00       	jmp    2f7 <ls+0x249>
  }
  
  switch(st.type){
 13a:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 141:	98                   	cwtl   
 142:	83 f8 01             	cmp    $0x1,%eax
 145:	74 53                	je     19a <ls+0xec>
 147:	83 f8 02             	cmp    $0x2,%eax
 14a:	0f 85 9c 01 00 00    	jne    2ec <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 150:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 156:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 163:	0f bf d8             	movswl %ax,%ebx
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	89 04 24             	mov    %eax,(%esp)
 16c:	e8 8f fe ff ff       	call   0 <fmtname>
 171:	89 7c 24 14          	mov    %edi,0x14(%esp)
 175:	89 74 24 10          	mov    %esi,0x10(%esp)
 179:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 17d:	89 44 24 08          	mov    %eax,0x8(%esp)
 181:	c7 44 24 04 67 0b 00 	movl   $0xb67,0x4(%esp)
 188:	00 
 189:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 190:	e8 e3 05 00 00       	call   778 <printf>
    break;
 195:	e9 52 01 00 00       	jmp    2ec <ls+0x23e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	89 04 24             	mov    %eax,(%esp)
 1a0:	e8 48 02 00 00       	call   3ed <strlen>
 1a5:	83 c0 10             	add    $0x10,%eax
 1a8:	3d 00 02 00 00       	cmp    $0x200,%eax
 1ad:	76 19                	jbe    1c8 <ls+0x11a>
      printf(1, "ls: path too long\n");
 1af:	c7 44 24 04 74 0b 00 	movl   $0xb74,0x4(%esp)
 1b6:	00 
 1b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1be:	e8 b5 05 00 00       	call   778 <printf>
      break;
 1c3:	e9 24 01 00 00       	jmp    2ec <ls+0x23e>
    }
    strcpy(buf, path);
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cf:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d5:	89 04 24             	mov    %eax,(%esp)
 1d8:	e8 9c 01 00 00       	call   379 <strcpy>
    p = buf+strlen(buf);
 1dd:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e3:	89 04 24             	mov    %eax,(%esp)
 1e6:	e8 02 02 00 00       	call   3ed <strlen>
 1eb:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1f1:	8d 04 02             	lea    (%edx,%eax,1),%eax
 1f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1fa:	c6 00 2f             	movb   $0x2f,(%eax)
 1fd:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 201:	e9 c0 00 00 00       	jmp    2c6 <ls+0x218>
      if(de.inum == 0)
 206:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 20d:	66 85 c0             	test   %ax,%ax
 210:	0f 84 af 00 00 00    	je     2c5 <ls+0x217>
        continue;
      memmove(p, de.name, DIRSIZ);
 216:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 21d:	00 
 21e:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 224:	83 c0 02             	add    $0x2,%eax
 227:	89 44 24 04          	mov    %eax,0x4(%esp)
 22b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22e:	89 04 24             	mov    %eax,(%esp)
 231:	e8 3c 03 00 00       	call   572 <memmove>
      p[DIRSIZ] = 0;
 236:	8b 45 e0             	mov    -0x20(%ebp),%eax
 239:	83 c0 0e             	add    $0xe,%eax
 23c:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 23f:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 245:	89 44 24 04          	mov    %eax,0x4(%esp)
 249:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 24f:	89 04 24             	mov    %eax,(%esp)
 252:	e8 81 02 00 00       	call   4d8 <stat>
 257:	85 c0                	test   %eax,%eax
 259:	79 20                	jns    27b <ls+0x1cd>
        printf(1, "ls: cannot stat %s\n", buf);
 25b:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 261:	89 44 24 08          	mov    %eax,0x8(%esp)
 265:	c7 44 24 04 53 0b 00 	movl   $0xb53,0x4(%esp)
 26c:	00 
 26d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 274:	e8 ff 04 00 00       	call   778 <printf>
        continue;
 279:	eb 4b                	jmp    2c6 <ls+0x218>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 27b:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 281:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 287:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 28e:	0f bf d8             	movswl %ax,%ebx
 291:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 297:	89 04 24             	mov    %eax,(%esp)
 29a:	e8 61 fd ff ff       	call   0 <fmtname>
 29f:	89 7c 24 14          	mov    %edi,0x14(%esp)
 2a3:	89 74 24 10          	mov    %esi,0x10(%esp)
 2a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2ab:	89 44 24 08          	mov    %eax,0x8(%esp)
 2af:	c7 44 24 04 67 0b 00 	movl   $0xb67,0x4(%esp)
 2b6:	00 
 2b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2be:	e8 b5 04 00 00       	call   778 <printf>
 2c3:	eb 01                	jmp    2c6 <ls+0x218>
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
 2c5:	90                   	nop
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2c6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2cd:	00 
 2ce:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2db:	89 04 24             	mov    %eax,(%esp)
 2de:	e8 19 03 00 00       	call   5fc <read>
 2e3:	83 f8 10             	cmp    $0x10,%eax
 2e6:	0f 84 1a ff ff ff    	je     206 <ls+0x158>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 2ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2ef:	89 04 24             	mov    %eax,(%esp)
 2f2:	e8 15 03 00 00       	call   60c <close>
}
 2f7:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2fd:	5b                   	pop    %ebx
 2fe:	5e                   	pop    %esi
 2ff:	5f                   	pop    %edi
 300:	5d                   	pop    %ebp
 301:	c3                   	ret    

00000302 <main>:

int
main(int argc, char *argv[])
{
 302:	55                   	push   %ebp
 303:	89 e5                	mov    %esp,%ebp
 305:	83 e4 f0             	and    $0xfffffff0,%esp
 308:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
 30b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 30f:	7f 11                	jg     322 <main+0x20>
    ls(".");
 311:	c7 04 24 87 0b 00 00 	movl   $0xb87,(%esp)
 318:	e8 91 fd ff ff       	call   ae <ls>
    exit();
 31d:	e8 c2 02 00 00       	call   5e4 <exit>
  }
  for(i=1; i<argc; i++)
 322:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 329:	00 
 32a:	eb 19                	jmp    345 <main+0x43>
    ls(argv[i]);
 32c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 330:	c1 e0 02             	shl    $0x2,%eax
 333:	03 45 0c             	add    0xc(%ebp),%eax
 336:	8b 00                	mov    (%eax),%eax
 338:	89 04 24             	mov    %eax,(%esp)
 33b:	e8 6e fd ff ff       	call   ae <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 340:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 345:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 349:	3b 45 08             	cmp    0x8(%ebp),%eax
 34c:	7c de                	jl     32c <main+0x2a>
    ls(argv[i]);
  exit();
 34e:	e8 91 02 00 00       	call   5e4 <exit>
 353:	90                   	nop

00000354 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 359:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35c:	8b 55 10             	mov    0x10(%ebp),%edx
 35f:	8b 45 0c             	mov    0xc(%ebp),%eax
 362:	89 cb                	mov    %ecx,%ebx
 364:	89 df                	mov    %ebx,%edi
 366:	89 d1                	mov    %edx,%ecx
 368:	fc                   	cld    
 369:	f3 aa                	rep stos %al,%es:(%edi)
 36b:	89 ca                	mov    %ecx,%edx
 36d:	89 fb                	mov    %edi,%ebx
 36f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 372:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 375:	5b                   	pop    %ebx
 376:	5f                   	pop    %edi
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    

00000379 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 385:	8b 45 0c             	mov    0xc(%ebp),%eax
 388:	0f b6 10             	movzbl (%eax),%edx
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	88 10                	mov    %dl,(%eax)
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	0f b6 00             	movzbl (%eax),%eax
 396:	84 c0                	test   %al,%al
 398:	0f 95 c0             	setne  %al
 39b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 39f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3a3:	84 c0                	test   %al,%al
 3a5:	75 de                	jne    385 <strcpy+0xc>
    ;
  return os;
 3a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3af:	eb 08                	jmp    3b9 <strcmp+0xd>
    p++, q++;
 3b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	0f b6 00             	movzbl (%eax),%eax
 3bf:	84 c0                	test   %al,%al
 3c1:	74 10                	je     3d3 <strcmp+0x27>
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 10             	movzbl (%eax),%edx
 3c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	38 c2                	cmp    %al,%dl
 3d1:	74 de                	je     3b1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	0f b6 d0             	movzbl %al,%edx
 3dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3df:	0f b6 00             	movzbl (%eax),%eax
 3e2:	0f b6 c0             	movzbl %al,%eax
 3e5:	89 d1                	mov    %edx,%ecx
 3e7:	29 c1                	sub    %eax,%ecx
 3e9:	89 c8                	mov    %ecx,%eax
}
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    

000003ed <strlen>:

uint
strlen(char *s)
{
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3fa:	eb 04                	jmp    400 <strlen+0x13>
 3fc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 400:	8b 45 fc             	mov    -0x4(%ebp),%eax
 403:	03 45 08             	add    0x8(%ebp),%eax
 406:	0f b6 00             	movzbl (%eax),%eax
 409:	84 c0                	test   %al,%al
 40b:	75 ef                	jne    3fc <strlen+0xf>
    ;
  return n;
 40d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 410:	c9                   	leave  
 411:	c3                   	ret    

00000412 <memset>:

void*
memset(void *dst, int c, uint n)
{
 412:	55                   	push   %ebp
 413:	89 e5                	mov    %esp,%ebp
 415:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 418:	8b 45 10             	mov    0x10(%ebp),%eax
 41b:	89 44 24 08          	mov    %eax,0x8(%esp)
 41f:	8b 45 0c             	mov    0xc(%ebp),%eax
 422:	89 44 24 04          	mov    %eax,0x4(%esp)
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	89 04 24             	mov    %eax,(%esp)
 42c:	e8 23 ff ff ff       	call   354 <stosb>
  return dst;
 431:	8b 45 08             	mov    0x8(%ebp),%eax
}
 434:	c9                   	leave  
 435:	c3                   	ret    

00000436 <strchr>:

char*
strchr(const char *s, char c)
{
 436:	55                   	push   %ebp
 437:	89 e5                	mov    %esp,%ebp
 439:	83 ec 04             	sub    $0x4,%esp
 43c:	8b 45 0c             	mov    0xc(%ebp),%eax
 43f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 442:	eb 14                	jmp    458 <strchr+0x22>
    if(*s == c)
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	0f b6 00             	movzbl (%eax),%eax
 44a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 44d:	75 05                	jne    454 <strchr+0x1e>
      return (char*)s;
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	eb 13                	jmp    467 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 454:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	0f b6 00             	movzbl (%eax),%eax
 45e:	84 c0                	test   %al,%al
 460:	75 e2                	jne    444 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 462:	b8 00 00 00 00       	mov    $0x0,%eax
}
 467:	c9                   	leave  
 468:	c3                   	ret    

00000469 <gets>:

char*
gets(char *buf, int max)
{
 469:	55                   	push   %ebp
 46a:	89 e5                	mov    %esp,%ebp
 46c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 46f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 476:	eb 44                	jmp    4bc <gets+0x53>
    cc = read(0, &c, 1);
 478:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 47f:	00 
 480:	8d 45 ef             	lea    -0x11(%ebp),%eax
 483:	89 44 24 04          	mov    %eax,0x4(%esp)
 487:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 48e:	e8 69 01 00 00       	call   5fc <read>
 493:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49a:	7e 2d                	jle    4c9 <gets+0x60>
      break;
    buf[i++] = c;
 49c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 49f:	03 45 08             	add    0x8(%ebp),%eax
 4a2:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 4a6:	88 10                	mov    %dl,(%eax)
 4a8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 4ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b0:	3c 0a                	cmp    $0xa,%al
 4b2:	74 16                	je     4ca <gets+0x61>
 4b4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b8:	3c 0d                	cmp    $0xd,%al
 4ba:	74 0e                	je     4ca <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4bf:	83 c0 01             	add    $0x1,%eax
 4c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4c5:	7c b1                	jl     478 <gets+0xf>
 4c7:	eb 01                	jmp    4ca <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4c9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4cd:	03 45 08             	add    0x8(%ebp),%eax
 4d0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4d6:	c9                   	leave  
 4d7:	c3                   	ret    

000004d8 <stat>:

int
stat(char *n, struct stat *st)
{
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4e5:	00 
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	89 04 24             	mov    %eax,(%esp)
 4ec:	e8 33 01 00 00       	call   624 <open>
 4f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 4f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f8:	79 07                	jns    501 <stat+0x29>
    return -1;
 4fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4ff:	eb 23                	jmp    524 <stat+0x4c>
  r = fstat(fd, st);
 501:	8b 45 0c             	mov    0xc(%ebp),%eax
 504:	89 44 24 04          	mov    %eax,0x4(%esp)
 508:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50b:	89 04 24             	mov    %eax,(%esp)
 50e:	e8 29 01 00 00       	call   63c <fstat>
 513:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 516:	8b 45 f0             	mov    -0x10(%ebp),%eax
 519:	89 04 24             	mov    %eax,(%esp)
 51c:	e8 eb 00 00 00       	call   60c <close>
  return r;
 521:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 524:	c9                   	leave  
 525:	c3                   	ret    

00000526 <atoi>:

int
atoi(const char *s)
{
 526:	55                   	push   %ebp
 527:	89 e5                	mov    %esp,%ebp
 529:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 52c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 533:	eb 24                	jmp    559 <atoi+0x33>
    n = n*10 + *s++ - '0';
 535:	8b 55 fc             	mov    -0x4(%ebp),%edx
 538:	89 d0                	mov    %edx,%eax
 53a:	c1 e0 02             	shl    $0x2,%eax
 53d:	01 d0                	add    %edx,%eax
 53f:	01 c0                	add    %eax,%eax
 541:	89 c2                	mov    %eax,%edx
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	0f b6 00             	movzbl (%eax),%eax
 549:	0f be c0             	movsbl %al,%eax
 54c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 54f:	83 e8 30             	sub    $0x30,%eax
 552:	89 45 fc             	mov    %eax,-0x4(%ebp)
 555:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 559:	8b 45 08             	mov    0x8(%ebp),%eax
 55c:	0f b6 00             	movzbl (%eax),%eax
 55f:	3c 2f                	cmp    $0x2f,%al
 561:	7e 0a                	jle    56d <atoi+0x47>
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	0f b6 00             	movzbl (%eax),%eax
 569:	3c 39                	cmp    $0x39,%al
 56b:	7e c8                	jle    535 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 56d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 570:	c9                   	leave  
 571:	c3                   	ret    

00000572 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 572:	55                   	push   %ebp
 573:	89 e5                	mov    %esp,%ebp
 575:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 578:	8b 45 08             	mov    0x8(%ebp),%eax
 57b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 57e:	8b 45 0c             	mov    0xc(%ebp),%eax
 581:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 584:	eb 13                	jmp    599 <memmove+0x27>
    *dst++ = *src++;
 586:	8b 45 fc             	mov    -0x4(%ebp),%eax
 589:	0f b6 10             	movzbl (%eax),%edx
 58c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 58f:	88 10                	mov    %dl,(%eax)
 591:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 595:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 599:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 59d:	0f 9f c0             	setg   %al
 5a0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 5a4:	84 c0                	test   %al,%al
 5a6:	75 de                	jne    586 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5ab:	c9                   	leave  
 5ac:	c3                   	ret    

000005ad <trampoline>:
 5ad:	5a                   	pop    %edx
 5ae:	59                   	pop    %ecx
 5af:	58                   	pop    %eax
 5b0:	c9                   	leave  
 5b1:	c3                   	ret    

000005b2 <signal>:
//	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 5b2:	55                   	push   %ebp
 5b3:	89 e5                	mov    %esp,%ebp
 5b5:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 5b8:	c7 44 24 08 ad 05 00 	movl   $0x5ad,0x8(%esp)
 5bf:	00 
 5c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	89 04 24             	mov    %eax,(%esp)
 5cd:	e8 ba 00 00 00       	call   68c <register_signal_handler>
	return 0;
 5d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 5d7:	c9                   	leave  
 5d8:	c3                   	ret    
 5d9:	90                   	nop
 5da:	90                   	nop
 5db:	90                   	nop

000005dc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5dc:	b8 01 00 00 00       	mov    $0x1,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <exit>:
SYSCALL(exit)
 5e4:	b8 02 00 00 00       	mov    $0x2,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <wait>:
SYSCALL(wait)
 5ec:	b8 03 00 00 00       	mov    $0x3,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <pipe>:
SYSCALL(pipe)
 5f4:	b8 04 00 00 00       	mov    $0x4,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <read>:
SYSCALL(read)
 5fc:	b8 05 00 00 00       	mov    $0x5,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <write>:
SYSCALL(write)
 604:	b8 10 00 00 00       	mov    $0x10,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <close>:
SYSCALL(close)
 60c:	b8 15 00 00 00       	mov    $0x15,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <kill>:
SYSCALL(kill)
 614:	b8 06 00 00 00       	mov    $0x6,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <exec>:
SYSCALL(exec)
 61c:	b8 07 00 00 00       	mov    $0x7,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <open>:
SYSCALL(open)
 624:	b8 0f 00 00 00       	mov    $0xf,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <mknod>:
SYSCALL(mknod)
 62c:	b8 11 00 00 00       	mov    $0x11,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <unlink>:
SYSCALL(unlink)
 634:	b8 12 00 00 00       	mov    $0x12,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <fstat>:
SYSCALL(fstat)
 63c:	b8 08 00 00 00       	mov    $0x8,%eax
 641:	cd 40                	int    $0x40
 643:	c3                   	ret    

00000644 <link>:
SYSCALL(link)
 644:	b8 13 00 00 00       	mov    $0x13,%eax
 649:	cd 40                	int    $0x40
 64b:	c3                   	ret    

0000064c <mkdir>:
SYSCALL(mkdir)
 64c:	b8 14 00 00 00       	mov    $0x14,%eax
 651:	cd 40                	int    $0x40
 653:	c3                   	ret    

00000654 <chdir>:
SYSCALL(chdir)
 654:	b8 09 00 00 00       	mov    $0x9,%eax
 659:	cd 40                	int    $0x40
 65b:	c3                   	ret    

0000065c <dup>:
SYSCALL(dup)
 65c:	b8 0a 00 00 00       	mov    $0xa,%eax
 661:	cd 40                	int    $0x40
 663:	c3                   	ret    

00000664 <getpid>:
SYSCALL(getpid)
 664:	b8 0b 00 00 00       	mov    $0xb,%eax
 669:	cd 40                	int    $0x40
 66b:	c3                   	ret    

0000066c <sbrk>:
SYSCALL(sbrk)
 66c:	b8 0c 00 00 00       	mov    $0xc,%eax
 671:	cd 40                	int    $0x40
 673:	c3                   	ret    

00000674 <sleep>:
SYSCALL(sleep)
 674:	b8 0d 00 00 00       	mov    $0xd,%eax
 679:	cd 40                	int    $0x40
 67b:	c3                   	ret    

0000067c <uptime>:
SYSCALL(uptime)
 67c:	b8 0e 00 00 00       	mov    $0xe,%eax
 681:	cd 40                	int    $0x40
 683:	c3                   	ret    

00000684 <halt>:
SYSCALL(halt)
 684:	b8 16 00 00 00       	mov    $0x16,%eax
 689:	cd 40                	int    $0x40
 68b:	c3                   	ret    

0000068c <register_signal_handler>:
SYSCALL(register_signal_handler)
 68c:	b8 17 00 00 00       	mov    $0x17,%eax
 691:	cd 40                	int    $0x40
 693:	c3                   	ret    

00000694 <alarm>:
SYSCALL(alarm)
 694:	b8 18 00 00 00       	mov    $0x18,%eax
 699:	cd 40                	int    $0x40
 69b:	c3                   	ret    

0000069c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 69c:	55                   	push   %ebp
 69d:	89 e5                	mov    %esp,%ebp
 69f:	83 ec 28             	sub    $0x28,%esp
 6a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6af:	00 
 6b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ba:	89 04 24             	mov    %eax,(%esp)
 6bd:	e8 42 ff ff ff       	call   604 <write>
}
 6c2:	c9                   	leave  
 6c3:	c3                   	ret    

000006c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6c4:	55                   	push   %ebp
 6c5:	89 e5                	mov    %esp,%ebp
 6c7:	53                   	push   %ebx
 6c8:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6d2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6d6:	74 17                	je     6ef <printint+0x2b>
 6d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6dc:	79 11                	jns    6ef <printint+0x2b>
    neg = 1;
 6de:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e8:	f7 d8                	neg    %eax
 6ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6ed:	eb 06                	jmp    6f5 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 6f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 6fc:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 6ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
 702:	8b 45 f4             	mov    -0xc(%ebp),%eax
 705:	ba 00 00 00 00       	mov    $0x0,%edx
 70a:	f7 f3                	div    %ebx
 70c:	89 d0                	mov    %edx,%eax
 70e:	0f b6 80 90 0b 00 00 	movzbl 0xb90(%eax),%eax
 715:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 719:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 71d:	8b 45 10             	mov    0x10(%ebp),%eax
 720:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 723:	8b 45 f4             	mov    -0xc(%ebp),%eax
 726:	ba 00 00 00 00       	mov    $0x0,%edx
 72b:	f7 75 d4             	divl   -0x2c(%ebp)
 72e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 735:	75 c5                	jne    6fc <printint+0x38>
  if(neg)
 737:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 73b:	74 2a                	je     767 <printint+0xa3>
    buf[i++] = '-';
 73d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 740:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 745:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 749:	eb 1d                	jmp    768 <printint+0xa4>
    putc(fd, buf[i]);
 74b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 74e:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 753:	0f be c0             	movsbl %al,%eax
 756:	89 44 24 04          	mov    %eax,0x4(%esp)
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	89 04 24             	mov    %eax,(%esp)
 760:	e8 37 ff ff ff       	call   69c <putc>
 765:	eb 01                	jmp    768 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 767:	90                   	nop
 768:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 76c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 770:	79 d9                	jns    74b <printint+0x87>
    putc(fd, buf[i]);
}
 772:	83 c4 44             	add    $0x44,%esp
 775:	5b                   	pop    %ebx
 776:	5d                   	pop    %ebp
 777:	c3                   	ret    

00000778 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 778:	55                   	push   %ebp
 779:	89 e5                	mov    %esp,%ebp
 77b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 77e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 785:	8d 45 0c             	lea    0xc(%ebp),%eax
 788:	83 c0 04             	add    $0x4,%eax
 78b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 78e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 795:	e9 7e 01 00 00       	jmp    918 <printf+0x1a0>
    c = fmt[i] & 0xff;
 79a:	8b 55 0c             	mov    0xc(%ebp),%edx
 79d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a0:	8d 04 02             	lea    (%edx,%eax,1),%eax
 7a3:	0f b6 00             	movzbl (%eax),%eax
 7a6:	0f be c0             	movsbl %al,%eax
 7a9:	25 ff 00 00 00       	and    $0xff,%eax
 7ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 7b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b5:	75 2c                	jne    7e3 <printf+0x6b>
      if(c == '%'){
 7b7:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 7bb:	75 0c                	jne    7c9 <printf+0x51>
        state = '%';
 7bd:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 7c4:	e9 4b 01 00 00       	jmp    914 <printf+0x19c>
      } else {
        putc(fd, c);
 7c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7cc:	0f be c0             	movsbl %al,%eax
 7cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d3:	8b 45 08             	mov    0x8(%ebp),%eax
 7d6:	89 04 24             	mov    %eax,(%esp)
 7d9:	e8 be fe ff ff       	call   69c <putc>
 7de:	e9 31 01 00 00       	jmp    914 <printf+0x19c>
      }
    } else if(state == '%'){
 7e3:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 7e7:	0f 85 27 01 00 00    	jne    914 <printf+0x19c>
      if(c == 'd'){
 7ed:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 7f1:	75 2d                	jne    820 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	8b 00                	mov    (%eax),%eax
 7f8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7ff:	00 
 800:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 807:	00 
 808:	89 44 24 04          	mov    %eax,0x4(%esp)
 80c:	8b 45 08             	mov    0x8(%ebp),%eax
 80f:	89 04 24             	mov    %eax,(%esp)
 812:	e8 ad fe ff ff       	call   6c4 <printint>
        ap++;
 817:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 81b:	e9 ed 00 00 00       	jmp    90d <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 820:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 824:	74 06                	je     82c <printf+0xb4>
 826:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 82a:	75 2d                	jne    859 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	8b 00                	mov    (%eax),%eax
 831:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 838:	00 
 839:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 840:	00 
 841:	89 44 24 04          	mov    %eax,0x4(%esp)
 845:	8b 45 08             	mov    0x8(%ebp),%eax
 848:	89 04 24             	mov    %eax,(%esp)
 84b:	e8 74 fe ff ff       	call   6c4 <printint>
        ap++;
 850:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 854:	e9 b4 00 00 00       	jmp    90d <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 859:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 85d:	75 46                	jne    8a5 <printf+0x12d>
        s = (char*)*ap;
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	8b 00                	mov    (%eax),%eax
 864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 867:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 86b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 86f:	75 27                	jne    898 <printf+0x120>
          s = "(null)";
 871:	c7 45 e4 89 0b 00 00 	movl   $0xb89,-0x1c(%ebp)
        while(*s != 0){
 878:	eb 1f                	jmp    899 <printf+0x121>
          putc(fd, *s);
 87a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 87d:	0f b6 00             	movzbl (%eax),%eax
 880:	0f be c0             	movsbl %al,%eax
 883:	89 44 24 04          	mov    %eax,0x4(%esp)
 887:	8b 45 08             	mov    0x8(%ebp),%eax
 88a:	89 04 24             	mov    %eax,(%esp)
 88d:	e8 0a fe ff ff       	call   69c <putc>
          s++;
 892:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 896:	eb 01                	jmp    899 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 898:	90                   	nop
 899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 89c:	0f b6 00             	movzbl (%eax),%eax
 89f:	84 c0                	test   %al,%al
 8a1:	75 d7                	jne    87a <printf+0x102>
 8a3:	eb 68                	jmp    90d <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8a5:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 8a9:	75 1d                	jne    8c8 <printf+0x150>
        putc(fd, *ap);
 8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ae:	8b 00                	mov    (%eax),%eax
 8b0:	0f be c0             	movsbl %al,%eax
 8b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 8b7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ba:	89 04 24             	mov    %eax,(%esp)
 8bd:	e8 da fd ff ff       	call   69c <putc>
        ap++;
 8c2:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 8c6:	eb 45                	jmp    90d <printf+0x195>
      } else if(c == '%'){
 8c8:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 8cc:	75 17                	jne    8e5 <printf+0x16d>
        putc(fd, c);
 8ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d1:	0f be c0             	movsbl %al,%eax
 8d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 8d8:	8b 45 08             	mov    0x8(%ebp),%eax
 8db:	89 04 24             	mov    %eax,(%esp)
 8de:	e8 b9 fd ff ff       	call   69c <putc>
 8e3:	eb 28                	jmp    90d <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8e5:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8ec:	00 
 8ed:	8b 45 08             	mov    0x8(%ebp),%eax
 8f0:	89 04 24             	mov    %eax,(%esp)
 8f3:	e8 a4 fd ff ff       	call   69c <putc>
        putc(fd, c);
 8f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8fb:	0f be c0             	movsbl %al,%eax
 8fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 902:	8b 45 08             	mov    0x8(%ebp),%eax
 905:	89 04 24             	mov    %eax,(%esp)
 908:	e8 8f fd ff ff       	call   69c <putc>
      }
      state = 0;
 90d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 914:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 918:	8b 55 0c             	mov    0xc(%ebp),%edx
 91b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 91e:	8d 04 02             	lea    (%edx,%eax,1),%eax
 921:	0f b6 00             	movzbl (%eax),%eax
 924:	84 c0                	test   %al,%al
 926:	0f 85 6e fe ff ff    	jne    79a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 92c:	c9                   	leave  
 92d:	c3                   	ret    
 92e:	90                   	nop
 92f:	90                   	nop

00000930 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 930:	55                   	push   %ebp
 931:	89 e5                	mov    %esp,%ebp
 933:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 936:	8b 45 08             	mov    0x8(%ebp),%eax
 939:	83 e8 08             	sub    $0x8,%eax
 93c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93f:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 944:	89 45 fc             	mov    %eax,-0x4(%ebp)
 947:	eb 24                	jmp    96d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 949:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94c:	8b 00                	mov    (%eax),%eax
 94e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 951:	77 12                	ja     965 <free+0x35>
 953:	8b 45 f8             	mov    -0x8(%ebp),%eax
 956:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 959:	77 24                	ja     97f <free+0x4f>
 95b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95e:	8b 00                	mov    (%eax),%eax
 960:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 963:	77 1a                	ja     97f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 965:	8b 45 fc             	mov    -0x4(%ebp),%eax
 968:	8b 00                	mov    (%eax),%eax
 96a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 96d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 970:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 973:	76 d4                	jbe    949 <free+0x19>
 975:	8b 45 fc             	mov    -0x4(%ebp),%eax
 978:	8b 00                	mov    (%eax),%eax
 97a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 97d:	76 ca                	jbe    949 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 97f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 982:	8b 40 04             	mov    0x4(%eax),%eax
 985:	c1 e0 03             	shl    $0x3,%eax
 988:	89 c2                	mov    %eax,%edx
 98a:	03 55 f8             	add    -0x8(%ebp),%edx
 98d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 990:	8b 00                	mov    (%eax),%eax
 992:	39 c2                	cmp    %eax,%edx
 994:	75 24                	jne    9ba <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 996:	8b 45 f8             	mov    -0x8(%ebp),%eax
 999:	8b 50 04             	mov    0x4(%eax),%edx
 99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99f:	8b 00                	mov    (%eax),%eax
 9a1:	8b 40 04             	mov    0x4(%eax),%eax
 9a4:	01 c2                	add    %eax,%edx
 9a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9af:	8b 00                	mov    (%eax),%eax
 9b1:	8b 10                	mov    (%eax),%edx
 9b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b6:	89 10                	mov    %edx,(%eax)
 9b8:	eb 0a                	jmp    9c4 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 9ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bd:	8b 10                	mov    (%eax),%edx
 9bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c7:	8b 40 04             	mov    0x4(%eax),%eax
 9ca:	c1 e0 03             	shl    $0x3,%eax
 9cd:	03 45 fc             	add    -0x4(%ebp),%eax
 9d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9d3:	75 20                	jne    9f5 <free+0xc5>
    p->s.size += bp->s.size;
 9d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d8:	8b 50 04             	mov    0x4(%eax),%edx
 9db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9de:	8b 40 04             	mov    0x4(%eax),%eax
 9e1:	01 c2                	add    %eax,%edx
 9e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ec:	8b 10                	mov    (%eax),%edx
 9ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f1:	89 10                	mov    %edx,(%eax)
 9f3:	eb 08                	jmp    9fd <free+0xcd>
  } else
    p->s.ptr = bp;
 9f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9fb:	89 10                	mov    %edx,(%eax)
  freep = p;
 9fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a00:	a3 bc 0b 00 00       	mov    %eax,0xbbc
}
 a05:	c9                   	leave  
 a06:	c3                   	ret    

00000a07 <morecore>:

static Header*
morecore(uint nu)
{
 a07:	55                   	push   %ebp
 a08:	89 e5                	mov    %esp,%ebp
 a0a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a0d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a14:	77 07                	ja     a1d <morecore+0x16>
    nu = 4096;
 a16:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a1d:	8b 45 08             	mov    0x8(%ebp),%eax
 a20:	c1 e0 03             	shl    $0x3,%eax
 a23:	89 04 24             	mov    %eax,(%esp)
 a26:	e8 41 fc ff ff       	call   66c <sbrk>
 a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 a2e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 a32:	75 07                	jne    a3b <morecore+0x34>
    return 0;
 a34:	b8 00 00 00 00       	mov    $0x0,%eax
 a39:	eb 22                	jmp    a5d <morecore+0x56>
  hp = (Header*)p;
 a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a44:	8b 55 08             	mov    0x8(%ebp),%edx
 a47:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4d:	83 c0 08             	add    $0x8,%eax
 a50:	89 04 24             	mov    %eax,(%esp)
 a53:	e8 d8 fe ff ff       	call   930 <free>
  return freep;
 a58:	a1 bc 0b 00 00       	mov    0xbbc,%eax
}
 a5d:	c9                   	leave  
 a5e:	c3                   	ret    

00000a5f <malloc>:

void*
malloc(uint nbytes)
{
 a5f:	55                   	push   %ebp
 a60:	89 e5                	mov    %esp,%ebp
 a62:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a65:	8b 45 08             	mov    0x8(%ebp),%eax
 a68:	83 c0 07             	add    $0x7,%eax
 a6b:	c1 e8 03             	shr    $0x3,%eax
 a6e:	83 c0 01             	add    $0x1,%eax
 a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 a74:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a80:	75 23                	jne    aa5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a82:	c7 45 f0 b4 0b 00 00 	movl   $0xbb4,-0x10(%ebp)
 a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8c:	a3 bc 0b 00 00       	mov    %eax,0xbbc
 a91:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 a96:	a3 b4 0b 00 00       	mov    %eax,0xbb4
    base.s.size = 0;
 a9b:	c7 05 b8 0b 00 00 00 	movl   $0x0,0xbb8
 aa2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa8:	8b 00                	mov    (%eax),%eax
 aaa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 aad:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ab0:	8b 40 04             	mov    0x4(%eax),%eax
 ab3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 ab6:	72 4d                	jb     b05 <malloc+0xa6>
      if(p->s.size == nunits)
 ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 abb:	8b 40 04             	mov    0x4(%eax),%eax
 abe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 ac1:	75 0c                	jne    acf <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ac6:	8b 10                	mov    (%eax),%edx
 ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 acb:	89 10                	mov    %edx,(%eax)
 acd:	eb 26                	jmp    af5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ad2:	8b 40 04             	mov    0x4(%eax),%eax
 ad5:	89 c2                	mov    %eax,%edx
 ad7:	2b 55 f4             	sub    -0xc(%ebp),%edx
 ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
 add:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ae0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ae3:	8b 40 04             	mov    0x4(%eax),%eax
 ae6:	c1 e0 03             	shl    $0x3,%eax
 ae9:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 aec:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
 af2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af8:	a3 bc 0b 00 00       	mov    %eax,0xbbc
      return (void*)(p + 1);
 afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b00:	83 c0 08             	add    $0x8,%eax
 b03:	eb 38                	jmp    b3d <malloc+0xde>
    }
    if(p == freep)
 b05:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 b0a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 b0d:	75 1b                	jne    b2a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b12:	89 04 24             	mov    %eax,(%esp)
 b15:	e8 ed fe ff ff       	call   a07 <morecore>
 b1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 b1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b21:	75 07                	jne    b2a <malloc+0xcb>
        return 0;
 b23:	b8 00 00 00 00       	mov    $0x0,%eax
 b28:	eb 13                	jmp    b3d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b33:	8b 00                	mov    (%eax),%eax
 b35:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b38:	e9 70 ff ff ff       	jmp    aad <malloc+0x4e>
}
 b3d:	c9                   	leave  
 b3e:	c3                   	ret    
