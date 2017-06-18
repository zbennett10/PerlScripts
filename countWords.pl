#!/user/bin/perl
use strict;
use warnings;

my $string = "There is no doubt that the skills needed to be successful in today's workforce have changed. Gone are the days in which workers can solely have the job skills that are required for their particular line of work. Today, it is very important to supplement these required skills with what are called 'soft skills'.

Soft skills are job/career skills that are intangible in nature. Examples include, but are not limited to: persuasive technique, communicative ability, leadership, and initiative. In the modern workforce,  these skills are integral to the success of not only individual employees but entire companies.

The first reason soft skills are important is due to the competitive nature of today's workforce. Nowadays, to be successful, an employee needs a way to stand out. The average work environment is often so competitive that having required job skills is not enough. Soft skills offer the perfect means by which employees can supplement their required skills and stand out - increasing the success of their career.

Soft skills are also important because of the positive way in which they impact an employee's private life.  As an employee gets better at communication and taking initiative, their private life will undoubtedly see more success. It is my belief that a successful private life will lead to a successful career. When a worker's private life is less stressful, this gives the worker far more energy/mindfulness when it comes to their job. This helps everyone involved!

In conclusion,  soft skills are not only a possible means of additional success in today's workforce but a crucial part of that success! Soft skills can improve an individual's job success directly, but also indirectly via bolstering one's private life.   Don't waste any time - improve your soft skills today!";

my @words = split(' ', $string);

print scalar(@words);