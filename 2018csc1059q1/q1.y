%{
#include <stdio.h> 
#include <stdlib.h> 
#include<string>
#include<iostream>
#include<map>
using namespace std;
map<string, double> vars;	//dictionary of variables and values
extern int yylex();
extern void yyerror(std::string str);
std::string conc(std::string s1 , std::string s2); // function to concatenate strings and return it to the callee.
std::string reverse_str(std::string s);           // function to reverse strings and return it to the callee.
std::string search(std::string s1 , std::string s2);   // function to return strings and return true/false  to the callee.
void UnknownVarError(std::string s);	//a primitive error handler - C++ (classes/objects) exception handlers 
				//could do elaborate handling of such/similar cases
%}

%union
{
 int 		int_val;
 double		double_val;
 std::string*	str_val;
}

%token <int_val>	CONCATENATE SEARCH REVERSE EQUALS PRINT LPAREN RPAREN SEMICOLON
%token <str_val>	VARIABLE
%token <double_val>	NUMBER

%type <str_val> expression;
%type <str_val> inner1;
%type <str_val> inner2;
%type <str_val> inner3;

%start lines

%%


lines       :lines line | line
            ;
line        :PRINT expression SEMICOLON		    {std::cout << *$2 << std::endl;}
	        ;
expression  :expression CONCATENATE inner1		{$$ = new std::string(conc(*$1 , *$3));}
		    | inner1				            {$$ = $1;}
            ;
inner1      :inner1 SEARCH inner2			    {$$ = new std::string(search(*$1 , *$3));}
		    | inner2				            {$$ = $1;}
            ;
inner2	    : inner2 REVERSE			        {$$ = new std::string(reverse_str(*$1));}
		|inner3					 {$$ = $1;}
inner3      :VARIABLE				            {$$=$1;}
		| LPAREN expression RPAREN		    {$$ = $2;}
            ;
%%


void UnknownVarError(std::string s)
{
	printf("Error: %s does not exist (undefined variablename)\n",s.c_str());
	exit(0);
}


std::string conc(std::string s1 , std::string s2){
    std::string s = s1+s2;
    return s;
}
std::string search(std::string s1 , std::string s2){

    int count1 = 0, count2 = 0, i, j, flag;

    while (s1[count1] != '\0')
        count1++;
    while (s2[count2] != '\0')
        count2++;
    for (i = 0; i <= count1 - count2; i++)
    {
        for (j = i; j < i + count2; j++)
        {
            flag = 1;
            if (s1[j] != s2[j - i])
            {
                flag = 0;
                break;
            }
        }
        if (flag == 1)
            break;
    }
    if (flag == 1)
       return "true";
    else
        return "false";
    
}
std::string reverse_str(std::string s){
    
   std::string r=s;
    int n = s.length(); 
    char tmp; 
    // corners 
    for (int i = 0; i < n / 2; i++){
              tmp=r[i];
              r[i]=r[n-i-1];
              r[n-i-1]=tmp;    
    }
        
    return r; 
}

