#Pacotes usados e comandos para instalação dos mesmos:
#install.packages('gmp', repos='http://cran.us.r-project.org')
#install.packages('stringi', repos='http://cran.us.r-project.org')

require(gmp)
require(stringi)

minPrimeNumber = 12  #O limite minimo de 12 é para "n" poder considerar pelo menos os caracteres alfabeticos que vão ate 122 em ASCII
maxPrimeNumber = 999 #A partir do 4º digito o processamento começa ficar mais lento para textos maiores

getChaveP = function() {
    isPrime = FALSE
    while(isPrime == FALSE) {
        primNumber = sample(minPrimeNumber:maxPrimeNumber,1) 
        if (isprime(primNumber) == 2) {
            isPrime = TRUE
        }
    }
    
    return(primNumber)
}

getChaveQ = function(p) {
    isPrime = FALSE
    while(isPrime == FALSE) {
        primNumber = sample(minPrimeNumber:maxPrimeNumber,1)
        if (primNumber != p && isprime(primNumber) == 2) {
            isPrime = TRUE
        }
    }

    return(primNumber)
}

getChaveN = function(p, q) {
    return(p * q)
}

getChaveNFi = function(p, q) {
    return((p - 1) * (q - 1))
}

getChaveE = function(nFi) {
    serv_e = 0
    for (i in 2:nFi) {
        if (gcd(nFi, i) == 1) {
            serv_e = i
            break
        }
    }

    return(serv_e)
}

getChaveD = function(nFi, e) {
    serv_d = 1
    repeat {
        if (serv_d < nFi && (serv_d * e) %% nFi == 1) {
            break
        }
        serv_d = serv_d + 1
    }
    return(serv_d)
}

toMsgCrypt = function(msg, e, n) {
    msgUTF8 = utf8ToInt(stringi::stri_enc_toascii(msg))

    resPotencia = msgUTF8 ^ as.bigz(e)
    msgCrypt = resPotencia %% n
    
    return(paste(as.character(msgCrypt), collapse = ","))
}

toMsgDecrypt = function(msgCrypt, d, n) {
    msgCrypt = as.bigz(unlist(strsplit(msgCrypt, split=",")))

    resPotencia = msgCrypt ^ as.bigz(d)
    msgDecrypt = resPotencia %% n

    msgDecrypt = as.integer(msgDecrypt)

    return(msg = intToUtf8(msgDecrypt))
}