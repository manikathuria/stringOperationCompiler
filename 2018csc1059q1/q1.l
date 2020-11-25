
%{
#include <stdio.h>
#include <string>
#include<iostream>
using namespace std;
#include "y.tab.h"
void yyerror(std::string str);
int yyparse(void);

%}
%%
"print"	   return PRINT;
[a-zA-Z][a-zA-Z0-9]* 	{yylval.str_val = new string(yytext); return VARIABLE;}
[0-9][0-9]*(.[0-9]+)?	{yylval.double_val = atof(yytext); return NUMBER;}
"="			return EQUALS;
"("			return LPAREN;
")"			return RPAREN;
";"			return SEMICOLON;
"?"         return SEARCH;
"<-"        return REVERSE;
"||"        return CONCATENATE;

%%



int yywrap(void)
{

}
void yyerror(std::string str)
{
	std::cout << "Error:" << str << std::endl;
}
int main(int num_args, char** args)
{
	if (num_args !=2)
	{
		printf("usage: ./parser1 filename\n");
		exit(0);
	}
	FILE* file1 = fopen(args[1],"r");
	if (file1 == NULL)
	{
		printf("Cannot open %s\n",args[1]);
		exit(0);
	}
	yyin = file1;
	yyparse();
	fclose(file1);
}


