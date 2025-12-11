enum ProductSorting {
  newest('Newest'),
  oldest('Oldest'),
  highestPrice('Highest Price'),
  lowestPrice('Lowest Price');

  const ProductSorting(this.title);
  final String title;
} 
