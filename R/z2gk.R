#' Transform standard normal draws to g-and-k.
#'
#' @param z A vector of standard normal draws.
#' @param A Vector of A (location) parameters.
#' @param B Vector of B (scale) parameters.  Must be positive.
#' @param g Vector of g parameters.
#' @param k Vector of k parameters.  Must be greater than -0.5.
#' @param c Vector of c parameters.  Often fixed at 0.8 (see Rayner and MacGillivray) which is the default.
#' @param theta Vector or matrix of parameter values. If this is supplied all other parameter arguments are ignored. A vector is treated as a single row matrix.  The columns may correspond to either 1) (A,B,g,k) with c taken to equal 0.8 or 2) (A,B,c,g,k).
#' @return A vector of g-and-k values.
z2gk <- function(z, A, B, g, k, c=0.8, theta=NULL){
  params <- check.params(A,B,g,k,c,theta)
  if (length(z) != length(params$A) & length(params$A) > 1) stop("Number of parameters supplied does not equal 1 or number of z values")
  temp <- params$A + params$B * (1+params$c*tanh(params$g*z/2)) * (1+z^2)^params$k * z
  temp <- ifelse(params$k<0 & is.infinite(z), z, temp) ##Otherwise get NaNs
  return(temp)
}

#' Transform one standard normal draw to g-and-k.
#'
#' @param z A standard normal draw.
#' @param theta Vector (A,B,c,g,k).
#' @return A g-and-k value.
z2gk.scalar <- function(z, theta) {
  if (!is.infinite(z^2)) {
      temp <- theta[1] + theta[2] * (1+theta[3]*tanh(theta[4]*z/2)) * (1+z^2)^theta[5] * z
  } else {
      ##This avoids wrong answers when z very large and k near its lower bound
      temp <- theta[1] + theta[2] * (1+theta[3]*tanh(theta[4]*z/2)) * abs(z)^(1+2*theta[5])
  }
  return(temp)
}
