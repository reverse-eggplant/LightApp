//
//  NSThreadConcurrent.h
//  LightApp
//
//  Created by malong on 14/11/21.
//  Copyright (c) 2014年 malong. All rights reserved.
//

/*
 *前瞻
 *程序：由源代码生成的可执行应用。（例如：微信.app）
 
 *进程：一个正在运行的程序可以看做一个进程（例如：正在运行的微信就是一个进程）。进程拥有独立运行所需的全部资源。
 
 *线程：（thread）是组成进程的子单元，操作系统的调度器可以对线程进行单独的调度。实际上，所有的并发编程 API 都是构建于线程之上的 —— 包括 GCD 和操作队列（operation queues）。多线程可以在单核 CPU 上同时（或者至少看作同时）运行。操作系统将小的时间片分配给每一个线程，这样就能够让用户感觉到有多个任务在同时进行。如果 CPU 是多核的，那么线程就可以真正的以并发方式被执行，从而减少了完成某项操作所需要的总时间。
 
 *一个进程是由一或多个线程组成。进程只负责资源的调度和分配，线程才是程序真正的执行单元，负责代码的执行。
 *每个正在运行的程序（即进程），至少包含一个线程，这个线程叫主线程。
 *主线程在程序启动时被创建，用于执行main函数。
 *只有一个主线程的程序，称作单线程程序。
 *单线程程序中，主线程负责执行程序的所有代码（UI展现以及刷新，网络请求，本地存储等等）。这些代码只能顺序执行，无法并发执行。
 
 *拥有多个线程的程序，称作多线程程序。
 *iOS允许用户自己开辟新的线程，相对于主线程来讲，这些线程，称作子线程。
 *可以根据需要开辟若干子线程,子线程和主线程是都是独立的运行单元，各自的执行互不影响，因此能够并发执行。
 
 *单线程程序：只有一个线程，代码顺序执行，容易出现代码阻塞（页面假死）
 *多线程程序：有多个线程，线程间独立运行，能有效的避免代码阻塞，并且提高程序的运行性能。
 *重点：iOS中关于UI的添加和刷新必须在主线程中操作。使用线程并不是没有代价的，每个线程都会消耗一些内存和内核资源。
 
 
 *GCD和operation queue :基于队列的并发编程 API
 
 */
#import <Foundation/Foundation.h>

@interface NSThreadConcurrent : NSObject

@end
